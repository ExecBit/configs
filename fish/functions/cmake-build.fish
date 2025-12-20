function echo_error
    echo (set_color red)"❌ $argv"(set_color normal)
end

function echo_success
    #echo (set_color green)"success    $argv"(set_color normal)
    echo (set_color green)">>> $argv"(set_color normal)
end

function echo_warning
    echo (set_color yellow)"⚠️  $argv"(set_color normal)
end

function echo_info
    #echo (set_color blue)"info       $argv"(set_color normal)
    echo (set_color blue)">>> $argv"(set_color normal)
end

function cmake-build --description "Build CMake project"
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
        echo_error "CMakeLists.txt not found"
        return 1
        cd "$project_root"
    end
    
    set -l project_name (basename $project_root)
    
    # Создаем директорию сборки
    set -l build_dir "$HOME/workspace/personal/builds/"(basename $project_root)"-$build_type"
    mkdir -p "$build_dir"
    
    echo_info "📦 Project: $project_name"
    echo_info "🎯 Build type: $build_type"
    echo_info "📁 Build directory: $build_dir"
    
    if test -n "$cmake_args"
        echo_info "⚙️  CMake options: $cmake_args"
    end
    
    # Переходим в директорию сборки
    cd "$build_dir"
    
    # Конфигурируем CMake
    set -l cmake_cmd cmake "$project_root" -DCMAKE_BUILD_TYPE=$build_type -DCMAKE_EXPORT_COMPILE_COMMANDS=ON $cmake_args
    
    echo_info "🔨 Configuring CMake..."
    if not eval $cmake_cmd
        echo_error "CMake configuration error"
        return 1
        cd "$project_root"
    end
    
    echo_success "Configuration completed"
    
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
        echo_success "Created symlink: compile_commands.json"
    else
        echo_warning "⚠️  compile_commands.json not created"
    end
    
    # Собираем проект
    echo_info "Building project..."
    
    if test -n "$target"
        echo_info "   Target: $target"
        if not cmake --build . --target "$target"
            echo_error "❌ Build target error '$target'"
            cd "$project_root"
            return 1
        end
    else
        set -l jobs (nproc)
        echo_info "Threads: $jobs"
        if not cmake --build . --parallel $jobs
            echo_error "Build error"
            cd "$project_root"
            return 1
        end
    end
    
    echo_success "Build completed!"
    
    # Возвращаемся в корень проекта
    cd "$project_root"
end
