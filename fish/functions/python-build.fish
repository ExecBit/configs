function python-build --description "Базовые операции с Python проектом"
    set -l action "help"
    
    if test -n "$argv[1]"
        set action $argv[1]
    end
    
    switch $action
        case build
            echo "📦 Собираю пакет..."
            python -m build
            
        case install
            echo "🔧 Устанавливаю..."
            pip install -e .
            
        case test
            echo "🧪 Запускаю тесты..."
            python -m pytest test_basic.py -v
            
        case venv
            echo "🌐 Создаю виртуальное окружение..."
            python -m venv .venv
            echo "✅ Создано .venv/"
            
        case clean
            echo "🧹 Очищаю..."
            rm -rf build dist *.egg-info __pycache__ .pytest_cache
            
        case help "*"
            echo "Доступные команды:"
            echo "  build    - Собрать пакет"
            echo "  install  - Установить в режиме разработки"
            echo "  test     - Запустить тесты"
            echo "  venv     - Создать виртуальное окружение"
            echo "  clean    - Очистить временные файлы"
    end
end
