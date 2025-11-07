"""
专为 AI Agent 设计的舆情搜索工具集

版本: 2.0
最后更新: 2025-11-06

此脚本将复杂的搜索功能分解为一系列目标明确、参数极少的独立工具，
专为AI Agent调用而设计。Agent只需根据任务意图选择合适的工具，
无需理解复杂的参数组合。

主要功能:
- Google Custom Search API 支持
- Semantic Scholar 学术搜索
- Reddit 社交媒体搜索
- HackerNews 科技新闻搜索
- ArXiv 学术预印本搜索

主要工具:
- google_custom_search: Google搜索API增强搜索
- semantic_scholar_search: 学术论文检索
- reddit_search: Reddit社区讨论搜索
- hackernews_search: HackerNews科技新闻
- arxiv_search: ArXiv学术预印本搜索
"""

import os
import sys
import json
import time
import requests
from typing import List, Dict, Any, Optional
from urllib.parse import urlencode, quote
from config import settings

# 添加utils目录到Python路径
current_dir = os.path.dirname(os.path.abspath(__file__))
root_dir = os.path.dirname(os.path.dirname(current_dir))
utils_dir = os.path.join(root_dir, 'utils')
if utils_dir not in sys.path:
    sys.path.append(utils_dir)

from retry_helper import with_graceful_retry, SEARCH_API_RETRY_CONFIG
from dataclasses import dataclass, field

# --- 1. 数据结构定义 ---

@dataclass
class SearchResult:
    """
    网页搜索结果数据类
    包含 published_date 属性来存储新闻发布日期
    """
    title: str
    url: str
    content: str
    score: Optional[float] = None
    raw_content: Optional[str] = None
    published_date: Optional[str] = None

@dataclass
class ImageResult:
    """图片搜索结果数据类"""
    url: str
    description: Optional[str] = None


# --- 2. 核心客户端与专用工具集 ---


# ================== 新增搜索客户端类 ====================

class SemanticScholarSearch:
    """Semantic Scholar API 客户端"""

    def __init__(self, api_key: Optional[str] = None):
        if api_key is None:
            api_key = os.getenv("SEMANTIC_SCHOLAR_API_KEY")

        self.api_key = api_key
        self.base_url = "https://api.semanticscholar.org/graph/v1"

    def search_papers(self, query: str, max_results: int = 10) -> List[SearchResult]:
        """搜索学术论文"""
        print(f"--- TOOL: 学术论文搜索 (query: {query}) ---")

        params = {
            'query': query,
            'limit': min(max_results, 100),
            'fields': 'title,abstract,authors,year,venue,citationCount'
        }

        headers = {}
        if self.api_key:
            headers['x-api-key'] = self.api_key

        try:
            response = requests.get(
                f"{self.base_url}/paper/search",
                params=params,
                headers=headers
            )
            response.raise_for_status()
            data = response.json()

            results = []
            for item in data.get('data', []):
                results.append(SearchResult(
                    title=item.get('title', ''),
                    url=f"https://www.semanticscholar.org/paper/{item.get('paperId', '')}",
                    content=item.get('abstract', ''),
                    published_date=str(item.get('year', ''))
                ))

            return results
        except Exception as e:
            print(f"Semantic Scholar搜索错误: {e}")
            return []


class RedditSearch:
    """Reddit API 客户端"""

    def __init__(self, client_id: Optional[str] = None, client_secret: Optional[str] = None):
        if client_id is None:
            client_id = settings.REDDIT_CLIENT_ID
        if client_secret is None:
            client_secret = settings.REDDIT_CLIENT_SECRET

        if not client_id or not client_secret:
            raise ValueError("Reddit API需要CLIENT_ID和CLIENT_SECRET")

        self.client_id = client_id
        self.client_secret = client_secret
        self.base_url = "https://oauth.reddit.com"
        self.token = self._get_token()

    def _get_token(self) -> str:
        """获取Reddit访问令牌"""
        auth = requests.auth.HTTPBasicAuth(self.client_id, self.client_secret)
        data = {'grant_type': 'client_credentials'}
        headers = {'User-Agent': 'BettaFish/1.0'}

        response = requests.post(
            'https://www.reddit.com/api/v1/access_token',
            auth=auth,
            data=data,
            headers=headers
        )

        if response.status_code == 200:
            return response.json().get('access_token')
        raise ValueError(f"Reddit认证失败: {response.status_code}")

    def search_posts(self, query: str, subreddit: Optional[str] = None, max_results: int = 10) -> List[SearchResult]:
        """搜索Reddit帖子"""
        print(f"--- TOOL: Reddit搜索 (query: {query}, subreddit: {subreddit}) ---")

        headers = {
            'Authorization': f'bearer {self.token}',
            'User-Agent': 'BettaFish/1.0'
        }

        search_url = f"{self.base_url}/search"
        params = {
            'q': query,
            'limit': min(max_results, 100),
            'sort': 'relevance',
            'type': 'link'
        }

        if subreddit:
            params['restrict_sr'] = 'true'
            search_url = f"{self.base_url}/r/{subreddit}/search"

        try:
            response = requests.get(search_url, params=params, headers=headers)
            response.raise_for_status()
            data = response.json()

            results = []
            for item in data.get('data', {}).get('children', []):
                post = item.get('data', {})
                results.append(SearchResult(
                    title=post.get('title', ''),
                    url=f"https://reddit.com{post.get('permalink', '')}",
                    content=post.get('selftext', ''),
                    published_date=time.strftime('%Y-%m-%d', time.localtime(post.get('created_utc', 0)))
                ))

            return results
        except Exception as e:
            print(f"Reddit搜索错误: {e}")
            return []


class HackerNewsSearch:
    """HackerNews API 客户端"""

    def __init__(self):
        self.base_url = "https://hacker-news.firebaseio.com/v0"

    def search_stories(self, query: str, max_results: int = 10) -> List[SearchResult]:
        """搜索HackerNews故事"""
        print(f"--- TOOL: HackerNews搜索 (query: {query}) ---")

        try:
            # 获取最新故事ID列表
            response = requests.get(f"{self.base_url}/newstories.json")
            story_ids = response.json()[:100]  # 只查看前100个

            results = []
            for story_id in story_ids[:max_results]:
                # 获取故事详情
                story_response = requests.get(f"{self.base_url}/item/{story_id}.json")
                story = story_response.json()

                if story and query.lower() in story.get('title', '').lower():
                    results.append(SearchResult(
                        title=story.get('title', ''),
                        url=story.get('url', f"https://news.ycombinator.com/item?id={story_id}"),
                        content=story.get('text', ''),
                        published_date=None
                    ))

                if len(results) >= max_results:
                    break

            return results
        except Exception as e:
            print(f"HackerNews搜索错误: {e}")
            return []


class ArxivSearch:
    """ArXiv API 客户端"""

    def __init__(self):
        self.base_url = "http://export.arxiv.org/api/query"

    def search_papers(self, query: str, max_results: int = 10, category: Optional[str] = None) -> List[SearchResult]:
        """搜索ArXiv论文"""
        print(f"--- TOOL: ArXiv搜索 (query: {query}, category: {category}) ---")

        search_query = f"all:{query}"
        if category:
            search_query += f" AND cat:{category}"

        params = {
            'search_query': search_query,
            'start': 0,
            'max_results': min(max_results, 100),
            'sortBy': 'relevance',
            'sortOrder': 'descending'
        }

        try:
            response = requests.get(self.base_url, params=params)
            response.raise_for_status()

            # 解析XML响应
            import xml.etree.ElementTree as ET
            root = ET.fromstring(response.content)

            results = []
            ns = {'atom': 'http://www.w3.org/2005/Atom', 'arxiv': 'http://arxiv.org/schemas/atom'}

            for entry in root.findall('atom:entry', ns):
                title = entry.find('atom:title', ns).text.strip()
                summary = entry.find('atom:summary', ns).text.strip()
                published = entry.find('atom:published', ns).text

                # 获取PDF链接
                pdf_link = None
                for link in entry.findall('atom:link', ns):
                    if link.get('type') == 'application/pdf':
                        pdf_link = link.get('href')
                        break

                results.append(SearchResult(
                    title=title,
                    url=pdf_link or entry.find('atom:id', ns).text,
                    content=summary,
                    published_date=published[:10]  # 只取日期部分
                ))

                if len(results) >= max_results:
                    break

            return results
        except Exception as e:
            print(f"ArXiv搜索错误: {e}")
            return []


# ================== 统一搜索接口 ====================

class ComprehensiveSearchEngine:
    """统一搜索引擎，整合所有搜索源"""

    def __init__(self):
        self.semantic_scholar = None
        self.reddit = None
        self.hackernews = None
        self.arxiv = None

        # 初始化可用的客户端
        try:
            self.semantic_scholar = SemanticScholarSearch()
        except:
            print("警告: Semantic Scholar未配置")

        try:
            self.reddit = RedditSearch()
        except:
            print("警告: Reddit API未配置")

        try:
            self.hackernews = HackerNewsSearch()
        except:
            print("警告: HackerNews初始化失败")

        try:
            self.arxiv = ArxivSearch()
        except:
            print("警告: ArXiv初始化失败")

    def search_all_sources(self, query: str, sources: List[str] = None, max_results: int = 5) -> Dict[str, List[SearchResult]]:
        """在所有或指定源中搜索"""
        if sources is None:
            sources = ['semantic_scholar', 'reddit', 'hackernews', 'arxiv']

        results = {}

        for source in sources:
            try:
                if source == 'semantic_scholar' and self.semantic_scholar:
                    results['semantic_scholar'] = self.semantic_scholar.search_papers(query, max_results)
                elif source == 'reddit' and self.reddit:
                    results['reddit'] = self.reddit.search_posts(query, max_results=max_results)
                elif source == 'hackernews' and self.hackernews:
                    results['hackernews'] = self.hackernews.search_stories(query, max_results)
                elif source == 'arxiv' and self.arxiv:
                    results['arxiv'] = self.arxiv.search_papers(query, max_results)
            except Exception as e:
                print(f"搜索源 {source} 错误: {e}")
                results[source] = []

        return results


# ================== 测试代码 ====================

if __name__ == "__main__":
    # 在运行前，请确保您已设置相应的API密钥环境变量

    try:
        # 初始化统一搜索引擎
        search_engine = ComprehensiveSearchEngine()

        # 场景1: 多源综合搜索
        print("=== 场景1: 多源综合搜索 ===")
        results = search_engine.search_all_sources("人工智能", max_results=3)
        for source, items in results.items():
            print(f"\n{source.upper()} ({len(items)} 结果):")
            for item in items[:2]:
                print(f"  - {item.title[:60]}...")

        # 场景2: 单源搜索示例
        print("\n=== 场景2: 学术搜索 ===")
        if search_engine.semantic_scholar:
            papers = search_engine.semantic_scholar.search_papers("machine learning", max_results=3)
            for paper in papers:
                print(f"  - {paper.title}")
                print(f"    {paper.published_date}")

    except Exception as e:
        print(f"测试过程中发生错误: {e}")
        print("请检查API密钥配置")