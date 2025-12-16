function python-project-test --description "Создать новый Python проект с современной структурой"
    set -l project_name $argv[1]
    
    if test -z "$project_name"
        echo "Использование: python-project-init <имя_проекта>"
        echo "Пример: python-project-init my-package"
        return 1
    end
    
    # Проверяем, не существует ли уже папка
    if test -d "$project_name"
        echo "Ошибка: Папка '$project_name' уже существует"
        return 1
    end
    
    # Нормализуем имя для Python (snake_case для папок, kebab-case для пакета)
    set -l package_name (echo $project_name | sed 's/-/_/g')  # my-package → my_package
    set -l module_name (echo $project_name | sed 's/_/-/g')   # my_package → my-package
    
    echo "Создаю Python проект: $project_name"
    echo "Имя пакета: $package_name"
    
    # Создаем структуру проекта
    mkdir -p "$project_name"/{src,tests,docs,examples,scripts}
    mkdir -p "$project_name/src/$package_name"
    
    # Создаем основные файлы
    _create_pyproject_toml "$project_name" "$package_name" "$module_name"
    _create_setup_cfg "$project_name" "$package_name"
#   _create_readme "$project_name" "$package_name"
    _create_gitignore "$project_name"
#   _create_license "$project_name"
    _create_source_files "$project_name" "$package_name"
#   _create_test_files "$project_name" "$package_name"
#   _create_config_files "$project_name"
    
    echo ""
    echo "✅ Проект '$project_name' создан!"
    echo ""
    echo "📁 Структура проекта:"
    tree "$project_name" -I '__pycache__|*.pyc'
    echo ""
    echo "🚀 Следующие шаги:"
    echo "   cd $project_name"
    echo "   python -m venv .venv           # Создать виртуальное окружение"
    echo "   source .venv/bin/activate      # Активировать его"
    echo "   pip install -e .               # Установить пакет в режиме разработки"
    echo "   pip install -r requirements-dev.txt  # Установить dev-зависимости"
    echo ""
    echo "🧪 Для запуска тестов: pytest"
    echo "📦 Для сборки: python -m build"
end

function _create_pyproject_toml
    set project_name $argv[1]
    set package_name $argv[2]
    set module_name $argv[3]
    
    echo "\
[build-system]
requires = [\"setuptools>=61.0\", \"wheel\"]
build-backend = \"setuptools.build_meta\"

[project]
name = \"$module_name\"
version = \"0.1.0\"
description = \"A Python package\"
readme = \"README.md\"
license = {text = \"MIT\"}
authors = [
    {name = \"Your Name\", email = \"your.email@example.com\"}
]
keywords = [\"python\", \"package\"]
classifiers = [
    \"Development Status :: 3 - Alpha\",
    \"Intended Audience :: Developers\",
    \"License :: OSI Approved :: MIT License\",
    \"Programming Language :: Python :: 3\",
    \"Programming Language :: Python :: 3.8\",
    \"Programming Language :: Python :: 3.9\",
    \"Programming Language :: Python :: 3.10\",
    \"Programming Language :: Python :: 3.11\",
]
requires-python = \">=3.8\"
dependencies = [
    # \"requests>=2.28.0\",
    # \"numpy>=1.21.0\",
]

[project.optional-dependencies]
dev = [
    \"pytest>=7.0.0\",
    \"pytest-cov>=4.0.0\",
    \"black>=23.0.0\",
    \"isort>=5.12.0\",
    \"flake8>=6.0.0\",
    \"mypy>=1.0.0\",
    \"pre-commit>=3.0.0\",
]
docs = [
    \"sphinx>=6.0.0\",
    \"sphinx-rtd-theme>=1.0.0\",
]

[project.urls]
Homepage = \"https://github.com/username/$module_name\"
Repository = \"https://github.com/username/$module_name.git\"
\"Issues\" = \"https://github.com/username/$module_name/issues\"

[project.scripts]
$package_name = \"$package_name.cli:main\"

[tool.setuptools]
packages = [\"$package_name\"]

[tool.setuptools.package-dir]
\"\" = \"src\"

[tool.black]
line-length = 88
target-version = ['py38', 'py39', 'py310', 'py311']

[tool.isort]
profile = \"black\"
line_length = 88

[tool.mypy]
python_version = \"3.8\"
warn_return_any = true
warn_unused_configs = true
disallow_untyped_defs = true

[tool.pytest.ini_options]
testpaths = [\"tests\"]
python_files = [\"test_*.py\"]
python_classes = [\"Test*\"]
python_functions = [\"test_*\"]
addopts = \"-v --cov=src/$package_name --cov-report=term-missing\"
" > "$project_name/pyproject.toml"
end

function _create_setup_cfg
    set project_name $argv[1]
    set package_name $argv[2]
    
    # Альтернативный конфиг для setuptools
    echo "\
[metadata]
name = $package_name
version = 0.1.0
author = Your Name
author_email = your.email@example.com
description = A Python package
long_description = file: README.md
long_description_content_type = text/markdown
url = https://github.com/username/$package_name
license = MIT
classifiers =
    Development Status :: 3 - Alpha
    Intended Audience :: Developers
    License :: OSI Approved :: MIT License
    Programming Language :: Python :: 3
    Programming Language :: Python :: 3.8
    Programming Language :: Python :: 3.9
    Programming Language :: Python :: 3.10
    Programming Language :: Python :: 3.11

[options]
package_dir =
    = src
packages = find:
python_requires = >=3.8
install_requires =
    # requests>=2.28.0
    # numpy>=1.21.0

[options.packages.find]
where = src

[options.extras_require]
dev =
    pytest>=7.0.0
    pytest-cov>=4.0.0
    black>=23.0.0
    isort>=5.12.0
    flake8>=6.0.0
    mypy>=1.0.0
docs =
    sphinx>=6.0.0
    sphinx-rtd-theme>=1.0.0

[options.entry_points]
console_scripts =
    $package_name = $package_name.cli:main
" > "$project_name/setup.cfg"
end

function _create_readme
    set project_name $argv[1]
    set package_name $argv[2]
    
    echo "\
# $project_name

A Python package.

## Features

- Feature 1
- Feature 2
- Feature 3

## Installation

### From PyPI (when published)

\`\`\`bash
pip install $package_name
\`\`\`

### From source (development)

\`\`\`bash
git clone https://github.com/username/$package_name.git
cd $package_name
python -m venv .venv
source .venv/bin/activate  # On Windows: .venv\\Scripts\\activate
pip install -e .[dev]
\`\`\`

## Usage

\`\`\`python
import $package_name

result = $package_name.some_function()
print(result)
\`\`\`

### Command Line Interface

\`\`\`bash
$package_name --help
\`\`\`

## Development

### Setup development environment

\`\`\`bash
# Install package in editable mode with development dependencies
pip install -e .[dev]

# Install pre-commit hooks
pre-commit install
\`\`\`

### Running tests

\`\`\`bash
pytest
pytest --cov=src/$package_name  # with coverage
\`\`\`

### Code formatting

\`\`\`bash
black src tests
isort src tests
flake8 src tests
mypy src
\`\`\`

### Building distribution

\`\`\`bash
python -m build  # builds both wheel and sdist
\`\`\`

## License

MIT
" > "$project_name/README.md"
end

function _create_gitignore
    set project_name $argv[1]
    
    echo "\
# Python
__pycache__/
*.py[cod]
*$py.class
*.so
.Python
build/
develop-eggs/
dist/
downloads/
eggs/
.eggs/
lib/
lib64/
parts/
sdist/
var/
wheels/
*.egg-info/
.installed.cfg
*.egg
MANIFEST

# Virtual Environment
.venv
env/
venv/
ENV/
env.bak/
venv.bak/

# IDE
.vscode/
.idea/
*.swp
*.swo
*~

# OS
.DS_Store
Thumbs.db

# Testing
.coverage
.coverage.*
.cache
nosetests.xml
coverage.xml
*.cover
*.log

# Documentation
docs/_build/
docs/source/generated/

# Jupyter Notebook
.ipynb_checkpoints

# PyCharm
.idea/

# mypy
.mypy_cache/
.dmypy.json
dmypy.json

# Pyre type checker
.pyre/
" > "$project_name/.gitignore"
end

function _create_license
    set project_name $argv[1]
    
    echo "\
MIT License

Copyright (c) $(date +%Y) Your Name

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the \"Software\"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED \"AS IS\", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
" > "$project_name/LICENSE"
end

function _create_source_files
    set project_name $argv[1]
    set package_name $argv[2]
    
    # Основной файл пакета
    echo "\
\"\"\"Main package module.\"\"\"

__version__ = \"0.1.0\"
__author__ = \"Your Name\"


def hello(name: str = \"World\") -> str:
    \"\"\"
    Return a greeting message.
    
    Args:
        name: Name to greet
        
    Returns:
        Greeting message
    \"\"\"
    return f\"Hello, {name}!\"


def add(a: float, b: float) -> float:
    \"\"\"Add two numbers.\"\"\"
    return a + b


class Calculator:
    \"\"\"A simple calculator class.\"\"\"
    
    def __init__(self, initial_value: float = 0.0):
        self.value = initial_value
    
    def add(self, x: float) -> \"Calculator\":
        \"\"\"Add value.\"\"\"
        self.value += x
        return self
    
    def subtract(self, x: float) -> \"Calculator\":
        \"\"\"Subtract value.\"\"\"
        self.value -= x
        return self
    
    def get_value(self) -> float:
        \"\"\"Get current value.\"\"\"
        return self.value
" > "$project_name/src/$package_name/__init__.py"

    # CLI модуль
    echo "\
\"\"\"Command line interface for $package_name.\"\"\"

import argparse
import sys
from typing import Optional, Sequence

from $package_name import __version__, hello


def main(argv: Optional[Sequence[str]] = None) -> int:
    \"\"\"Main entry point for CLI.\"\"\"
    parser = argparse.ArgumentParser(
        description=\"$package_name - A Python package\",
        formatter_class=argparse.RawDescriptionHelpFormatter,
    )
    
    parser.add_argument(
        \"--version\",
        action=\"version\",
        version=f\"$package_name {__version__}\",
    )
    
    parser.add_argument(
        \"name\",
        nargs=\"?\",
        default=\"World\",
        help=\"Name to greet (default: World)\",
    )
    
    parser.add_argument(
        \"-v\", \"--verbose\",
        action=\"store_true\",
        help=\"Enable verbose output\",
    )
    
    args = parser.parse_args(argv)
    
    if args.verbose:
        print(f\"Greeting {args.name}...\")
    
    result = hello(args.name)
    print(result)
    
    return 0


if __name__ == \"__main__":
    sys.exit(main())
" > "$project_name/src/$package_name/cli.py"

    # Утилиты
    echo "\
\"\"\"Utility functions.\"\"\"

import logging
from pathlib import Path
from typing import Any, Dict, List, Optional, Union

logger = logging.getLogger(__name__)


def setup_logging(level: int = logging.INFO) -> None:
    \"\"\"Setup basic logging configuration.\"\"\"
    logging.basicConfig(
        level=level,
        format=\"%(asctime)s - %(name)s - %(levelname)s - %(message)s\",
        datefmt=\"%Y-%m-%d %H:%M:%S\",
    )


def read_file(path: Union[str, Path]) -> str:
    \"\"\"Read file content.\"\"\"
    path = Path(path)
    if not path.exists():
        raise FileNotFoundError(f\"File not found: {path}\")
    return path.read_text(encoding=\"utf-8\")
" > "$project_name/src/$package_name/utils.py"
end

function _create_test_files
    set project_name $argv[1]
    set package_name $argv[2]
    
    # Основные тесты
    echo "\
\"\"\"Tests for $package_name package.\"\"\"

import pytest
from $package_name import __version__, hello, add, Calculator


def test_version():
    \"\"\"Test package version.\"\"\"
    assert __version__ == \"0.1.0\"


def test_hello():
    \"\"\"Test hello function.\"\"\"
    assert hello() == \"Hello, World!\"
    assert hello(\"Alice\") == \"Hello, Alice!\"


def test_add():
    \"\"\"Test add function.\"\"\"
    assert add(2, 3) == 5
    assert add(-1, 1) == 0
    assert add(0, 0) == 0


class TestCalculator:
    \"\"\"Test Calculator class.\"\"\"
    
    def test_initial_value(self):
        calc = Calculator()
        assert calc.get_value() == 0.0
        
        calc = Calculator(10.0)
        assert calc.get_value() == 10.0
    
    def test_add(self):
        calc = Calculator()
        calc.add(5)
        assert calc.get_value() == 5.0
        
        calc.add(-2)
        assert calc.get_value() == 3.0
    
    def test_subtract(self):
        calc = Calculator(10)
        calc.subtract(3)
        assert calc.get_value() == 7.0
        
        calc.subtract(2)
        assert calc.get_value() == 5.0
    
    def test_chaining(self):
        calc = Calculator()
        result = calc.add(5).subtract(2).add(10)
        assert result.get_value() == 13.0
        assert isinstance(result, Calculator)


def test_hello_type_error():
    \"\"\"Test hello function with wrong type.\"\"\"
    with pytest.raises(TypeError):
        hello(123)  # type: ignore
" > "$project_name/tests/test_basic.py"

    # Тесты для CLI
    echo "\
\"\"\"Tests for CLI.\"\"\"

import subprocess
import sys
from pathlib import Path

import pytest
from $package_name.cli import main


def test_cli_help():
    \"\"\"Test CLI help.\"\"\"
    result = subprocess.run(
        [sys.executable, \"-m\", \"$package_name.cli\", \"--help\"],
        capture_output=True,
        text=True,
    )
    assert result.returncode == 0
    assert \"usage:\" in result.stdout.lower()
    assert \"$package_name\" in result.stdout


def test_cli_version():
    \"\"\"Test CLI version.\"\"\"
    result = subprocess.run(
        [sys.executable, \"-m\", \"$package_name.cli\", \"--version\"],
        capture_output=True,
        text=True,
    )
    assert result.returncode == 0
    assert \"0.1.0\" in result.stdout


def test_cli_greet():
    \"\"\"Test CLI greeting.\"\"\"
    result = subprocess.run(
        [sys.executable, \"-m\", \"$package_name.cli\", \"Alice\"],
        capture_output=True,
        text=True,
    )
    assert result.returncode == 0
    assert \"Hello, Alice!\" in result.stdout


def test_main_function():
    \"\"\"Test main function directly.\"\"\"
    # Test with argument
    import io
    from contextlib import redirect_stdout
    
    f = io.StringIO()
    with redirect_stdout(f):
        result = main([\"Bob\"])
    
    assert result == 0
    assert \"Hello, Bob!\" in f.getvalue()
    
    # Test without argument (default)
    f = io.StringIO()
    with redirect_stdout(f):
        result = main([])
    
    assert result == 0
    assert \"Hello, World!\" in f.getvalue()
" > "$project_name/tests/test_cli.py"

    # conftest.py для настроек pytest
    echo "\
\"\"\"Pytest configuration.\"\"\"

import sys
from pathlib import Path

# Add src to Python path
src_path = Path(__file__).parent.parent / \"src\"
sys.path.insert(0, str(src_path))

# Fixtures can be defined here
import pytest


@pytest.fixture
def sample_data():
    \"\"\"Sample test data.\"\"\"
    return {\"key\": \"value\", \"number\": 42}


@pytest.fixture
def temp_dir(tmp_path):
    \"\"\"Temporary directory fixture.\"\"\"
    return tmp_path
" > "$project_name/tests/conftest.py"
end

function _create_config_files
    set project_name $argv[1]
    
    # requirements-dev.txt (для удобства)
    echo "\
# Development requirements
-e .[dev]

# Additional development tools
ipython
jupyter
pdbpp

# Linting and formatting
black
isort
flake8
mypy
pre-commit

# Testing
pytest
pytest-cov
pytest-xdist

# Documentation
sphinx
sphinx-rtd-theme
" > "$project_name/requirements-dev.txt"

    # requirements.txt (основные зависимости)
    echo "\
# Production dependencies
# requests>=2.28.0
# numpy>=1.21.0
" > "$project_name/requirements.txt"

    # .pre-commit-config.yaml
    echo "\
repos:
  - repo: https://github.com/pre-commit/pre-commit-hooks
    rev: v4.4.0
    hooks:
      - id: trailing-whitespace
      - id: end-of-file-fixer
      - id: check-yaml
      - id: check-added-large-files
      - id: check-merge-conflict
      - id: check-toml
      - id: check-json

  - repo: https://github.com/psf/black
    rev: 23.3.0
    hooks:
      - id: black
        language_version: python3

  - repo: https://github.com/pycqa/isort
    rev: 5.12.0
    hooks:
      - id: isort
        args: [\"--profile\", \"black\"]

  - repo: https://github.com/pycqa/flake8
    rev: 6.0.0
    hooks:
      - id: flake8
        args: [\"--max-line-length=88\", \"--extend-ignore=E203,W503\"]

  - repo: https://github.com/pre-commit/mirrors-mypy
    rev: v1.3.0
    hooks:
      - id: mypy
        args: [--ignore-missing-imports]
        additional_dependencies:
          - types-requests
          - types-pyyaml

  - repo: https://github.com/pre-commit/mirrors-prettier
    rev: \"v3.0.0-alpha.9-for-vscode\"
    hooks:
      - id: prettier
        types_or: [yaml, markdown, json]
" > "$project_name/.pre-commit-config.yaml"

    # setup.py (для обратной совместимости)
    echo "\
#!/usr/bin/env python
\"\"\"Setup script for $project_name.\"\"\"

from setuptools import setup

if __name__ == \"__main__\":
    setup()
" > "$project_name/setup.py"
    chmod +x "$project_name/setup.py"
    
    # .editorconfig
    echo "\
root = true

[*]
indent_style = space
indent_size = 4
end_of_line = lf
charset = utf-8
trim_trailing_whitespace = true
insert_final_newline = true

[*.py]
max_line_length = 88

[*.{yaml,yml}]
indent_size = 2

[*.md]
trim_trailing_whitespace = false
" > "$project_name/.editorconfig"

    # Dockerfile (опционально)
    echo "\
FROM python:3.11-slim as builder

WORKDIR /app

# Install build dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
    gcc \
    g++ \
    && rm -rf /var/lib/apt/lists/*

# Copy requirements first for better caching
COPY requirements.txt .
RUN pip install --user --no-cache-dir -r requirements.txt

# Copy application
COPY . .

# Install package
RUN pip install --user --no-cache-dir .

FROM python:3.11-slim

WORKDIR /app

# Copy installed packages from builder
COPY --from=builder /root/.local /root/.local

# Make sure scripts in .local are available
ENV PATH=/root/.local/bin:\$PATH

# Create non-root user
RUN useradd --create-home appuser
USER appuser

# Copy application code
COPY --chown=appuser:appuser . .

# Default command
CMD [\"$package_name\", \"--help\"]
" > "$project_name/Dockerfile"

    # docker-compose.yml для разработки
    echo "\
version: '3.8'

services:
  app:
    build: .
    volumes:
      - .:/app
    working_dir: /app
    command: python -m $package_name --help

  tests:
    build: .
    volumes:
      - .:/app
    working_dir: /app
    command: pytest -v

  lint:
    build: .
    volumes:
      - .:/app
    working_dir: /app
    command: >
      sh -c \"black --check src tests &&
              isort --check-only src tests &&
              flake8 src tests\"
" > "$project_name/docker-compose.yml"
end
