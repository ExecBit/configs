function cmake-build --description "Собрать CMake проект с созданием симлинка compile_commands.json"
    set -l build_type "Debug"
    set -l target ""
    set -l cmake_args ""
    
    # Парсинг аргументов
    for arg in $argv
        switch $arg
            case debug release relwithdebinfo minsizerel
                set build_type (string replace -r '^(.)' (string upper -- (string sub -l 1 $arg)) $arg)
            case "-D*" "-G*" "-U*" "-C*" "-W*"
                set cmake_args $cmake_args $arg
            case "*"
                # Если не начинается с дефиса, считаем это целью сборки
                if not string match -q -- "-*" "$arg"
                    set target $arg
                else
                    set cmake_args $cmake_args $arg
                end
        end
    end
    
    # Определяем корень проекта (ищем CMakeLists.txt)
    set -l project_root (pwd)
    while test $project_root != "/"
        if test -f "$project_root/CMakeLists.txt"
            break
        end
        set project_root (dirname $project_root)
    end
    
    if test $project_root = "/"
        echo "❌ CMakeLists.txt не найден"
        return 1
        cd "$project_root"
    end
    
    set -l project_name (basename $project_root)
    
    # Создаем директорию сборки
    set -l build_dir "$HOME/workspace/personal/builds/"(basename $project_root)"-$build_type"
    mkdir -p "$build_dir"
    
    echo "📦 Проект: $project_name"
    echo "🎯 Тип сборки: $build_type"
    echo "📁 Директория сборки: $build_dir"
    
    if test -n "$cmake_args"
        echo "⚙️  Опции CMake: $cmake_args"
    end
    
    # Переходим в директорию сборки
    cd "$build_dir"
    
    # Конфигурируем CMake
    set -l cmake_cmd cmake "$project_root" -DCMAKE_BUILD_TYPE=$build_type -DCMAKE_EXPORT_COMPILE_COMMANDS=ON $cmake_args
    
    echo "🔨 Конфигурирую CMake..."
    if not eval $cmake_cmd
        echo "❌ Ошибка конфигурации CMake"
        return 1
        cd "$project_root"
    end
    
    echo "✅ Конфигурация завершена"
    
    # Создаем симлинк compile_commands.json
    if test -f "$build_dir/compile_commands.json"
        set -l link_path "$project_root/compile_commands.json"
        
        # Удаляем старый симлинк или файл
        if test -L "$link_path"
            rm "$link_path"
        else if test -f "$link_path"
            mv "$link_path" "$link_path.backup"
        end
        
        # Создаем новый симлинк
        ln -sf "$build_dir/compile_commands.json" "$link_path"
        echo "🔗 Создан симлинк compile_commands.json"
    else
        echo "⚠️  compile_commands.json не создан"
    end
    
    # Собираем проект
    echo "🔨 Собираю проект..."
    
    if test -n "$target"
        echo "   Цель: $target"
        if not cmake --build . --target "$target"
            echo "❌ Ошибка сборки цели '$target'"
            cd "$project_root"
            return 1
        end
    else
        set -l jobs (nproc)
        echo "   Потоков: $jobs"
        if not cmake --build . --parallel $jobs
            echo "❌ Ошибка сборки"
            cd "$project_root"
            return 1
        end
    end
    
    echo "✅ Сборка завершена!"
    
    # Возвращаемся в корень проекта
    cd "$project_root"
end
