function python-project-init --description "Создать минимальный Python проект"
    set -l project_name $argv[1]
    
    if test -z "$project_name"
        echo "Использование: python-project-init <имя_проекта>"
        return 1
    end
    
    if test -d "$project_name"
        echo "Ошибка: Папка '$project_name' уже существует"
        return 1
    end
    
    # Нормализуем имя
    set -l package_name (echo $project_name | sed 's/-/_/g')
    
    echo "Создаю Python проект: $project_name"
    
    # Только самая необходимая структура
    mkdir -p "$project_name"/src/"$package_name"
    
    # Минимальные файлы
    _create_pyproject_toml_minimal "$project_name" "$package_name"
    _create_readme_minimal "$project_name"
    _create_gitignore_minimal "$project_name"
    _create_init_file "$project_name" "$package_name"
    _create_main_file "$project_name" "$package_name"
    _create_test_file "$project_name" "$package_name"
    
    echo ""
    echo "✅ Проект '$project_name' создан!"
    echo ""
    echo "📁 Структура:"
    tree "$project_name"
    echo ""
    echo "🚀 Для начала работы:"
    echo "   cd $project_name"
    echo "   python -m venv .venv"
    echo "   source .venv/bin/activate"
    echo "   pip install -e ."
    echo "   python -m $package_name"
end

function _create_pyproject_toml_minimal
    set project_name $argv[1]
    set package_name $argv[2]
    
    echo "\
[build-system]
requires = [\"setuptools>=61.0\", \"wheel\"]
build-backend = \"setuptools.build_meta\"

[project]
name = \"$project_name\"
version = \"0.1.0\"
authors = [{name = \"Your Name\"}]
description = \"A Python package\"
requires-python = \">=3.8\"

[project.optional-dependencies]
dev = [\"pytest\", \"black\"]

[tool.setuptools]
packages = [\"$package_name\"]

[tool.setuptools.package-dir]
\"\" = \"src\"
" > "$project_name/pyproject.toml"
end

function _create_readme_minimal
    set project_name $argv[1]
    
    echo "\
# $project_name

## Установка

\`\`\`bash
pip install -e .
\`\`\`

## Использование

\`\`\`python
import $project_name
\`\`\`
" > "$project_name/README.md"
end

function _create_gitignore_minimal
    set project_name $argv[1]
    
    echo "\
__pycache__/
*.pyc
.venv/
dist/
*.egg-info/
" > "$project_name/.gitignore"
end

function _create_init_file
    set project_name $argv[1]
    set package_name $argv[2]
    
    echo "\
\"\"\"$project_name package.\"\"\"

__version__ = \"0.1.0\"
" > "$project_name/src/$package_name/__init__.py"
end

function _create_main_file
    set project_name $argv[1]
    set package_name $argv[2]
    
    echo "\
def main():
    \"\"\"Main function.\"\"\"
    print(f\"Hello from {__package__}!\")
    return 0

if __name__ == \"__main__\":
    import sys
    sys.exit(main())
" > "$project_name/src/$package_name/__main__.py"
end

function _create_test_file
    set project_name $argv[1]
    set package_name $argv[2]
    
    echo "\
def test_version():
    import $package_name
    assert $package_name.__version__ == \"0.1.0\"

def test_main():
    import sys
    from $package_name.__main__ import main
    
    # Mock print to capture output
    import io
    from contextlib import redirect_stdout
    
    f = io.StringIO()
    with redirect_stdout(f):
        result = main()
    
    assert result == 0
    assert \"Hello from\" in f.getvalue()
" > "$project_name/test_basic.py"
end
