"""Main.

You can directly import the main function in your code.
"""

import csv
from urllib.parse import ParseResult, urljoin, urlparse
from uuid import uuid4

from pydantic import BaseModel

API_INDICATOR = ['v1', 'v2', 'v3', 'v4', 'v5', 'api', 'graphql', 'v1.1', 'v1.0']

ENDPOINTS_FILE = 'data/endpoints_with_services.csv'
SERVICES_FILE = 'data/services.csv'
KEEP_HEADERS = ['path', 'service', 'id', 'method', 'url']


def load_csv(filename: str) -> list[dict[str, str]]:
    with open(filename) as f:
        reader = csv.DictReader(f, skipinitialspace=True)
        return [{k: v for k, v in row.items() if k in KEEP_HEADERS} for row in reader]


def format_path(path: str) -> str:
    return f'/{path}'.replace('//', '/')


def format_url(url: str) -> str:
    return url.rstrip('/')


class APIBase(BaseModel):
    """Base class for API-related models with common URL parsing logic."""

    _id: str
    method: str = 'GET'

    @property
    def parsed_url(self) -> ParseResult:
        return urlparse(self.url)

    @property
    def subdomain(self) -> str:
        return format_url(self.parsed_url.netloc)

    @property
    def full_path(self) -> str:
        return format_path(self.parsed_url.path)

    @property
    def api_path(self) -> str:
        path_split = self.parsed_url.path.split('/')
        for i, el in enumerate(reversed(path_split)):
            if el in API_INDICATOR:
                return format_path('/'.join(path_split[len(path_split) - i :]))
        return format_path(self.parsed_url.path)

    @property
    def api_base_path(self) -> str:
        path_split = self.parsed_url.path.split('/')
        for i, el in enumerate(reversed(path_split)):
            if el in API_INDICATOR:
                return format_url(self.subdomain + '/' + '/'.join(path_split[: len(path_split) - i]))
        return format_url(self.subdomain)


class Endpoint(APIBase):
    """Represents an API endpoint with its path and service."""

    path: str
    service: str

    @property
    def url(self) -> str:
        return urljoin(self.service, self.path)


class Service(APIBase):
    """Represents a service with its URL."""

    url: str


def add_to_services_dict(item: APIBase, services_dict: dict) -> None:
    """Add an API item to the services dictionary.

    Args:
        item: APIBase instance (Endpoint or Service)
        services_dict: Dictionary to store grouped services
    """
    if item.api_base_path not in services_dict:
        services_dict[item.api_base_path] = {'GET /': Service(url=item.api_base_path, _id=str(uuid4()))}
    services_dict[item.api_base_path][f'{item.method} {item.api_path}'] = item


def main() -> None:
    """Entrypoint."""
    endpoints_data = load_csv(ENDPOINTS_FILE)
    services_data = load_csv(SERVICES_FILE)

    endpoints = [Endpoint(**endpoint) for endpoint in endpoints_data]
    services = [Service(**service) for service in services_data]

    all_services: dict = {}
    for item in [*endpoints, *services]:
        add_to_services_dict(item, all_services)

    for base_path, items in all_services.items():
        print('#' * 100)
        print(base_path)
        for item in items.values():
            print(item.method, item.api_path)
