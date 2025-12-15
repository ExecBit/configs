function project-init-test --description "Создать новый C++ проект с CMake"
    set -l project_name $argv[1]
    
    if test -z "$project_name"
        echo "Использование: project-init <имя_проекта>"
        echo "Пример: project-init my-library"
        return 1
    end
    
    # Проверяем, не существует ли уже папка
    if test -d "$project_name"
        echo "Ошибка: Папка '$project_name' уже существует"
        return 1
    end
    
    # Создаем структуру
    mkdir -p "$project_name"/{src,include,test,tools,docs,examples}
    mkdir -p "$project_name"/extern
    
    echo "Создаю проект: $project_name"
    
    # Создаем основные файлы
    _create_cmake_lists "$project_name"
    _create_gitignore "$project_name"
    _create_readme "$project_name"
    _create_example_files "$project_name"
    
    # Инициализируем git
    cd "$project_name"
    git init
    git add .
    git commit -m "Initial commit: $project_name"
    
    echo ""
    echo "✅ Проект '$project_name' успешно создан!"
    echo "📁 Переходим: cd $project_name"
    echo "🔨 Для сборки:"
    echo "   mkdir build && cd build"
    echo "   cmake .. && cmake --build ."
end

function _create_cmake_lists
    set project_name $argv[1]
    
    # Основной CMakeLists.txt
    echo "\
cmake_minimum_required(VERSION 3.20)
project($project_name VERSION 1.0.0 LANGUAGES CXX)

set(CMAKE_CXX_STANDARD 20)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_CXX_EXTENSIONS OFF)

# Опции сборки
option(BUILD_TESTS \"Build tests\" ON)
option(BUILD_EXAMPLES \"Build examples\" ON)

# Предупреждения
if(CMAKE_CXX_COMPILER_ID MATCHES \"GNU|Clang\")
    add_compile_options(-Wall -Wextra -Wpedantic -Werror)
endif()

# Добавляем библиотеку
add_library($project_name)

# Исходники
target_sources($project_name
    PRIVATE
        src/lib.cpp
    PUBLIC
        include/$project_name/lib.hpp
)

# Инклюд директории
target_include_directories($project_name
    PUBLIC
        \\\$<BUILD_INTERFACE:\\\${CMAKE_CURRENT_SOURCE_DIR}/include>
        \\\$<INSTALL_INTERFACE:include>
)

# Тесты
if(BUILD_TESTS)
    enable_testing()
    add_subdirectory(test)
endif()

" > "$project_name/CMakeLists.txt"

    # CMakeLists.txt для тестов
    echo "\
# Тесты для $project_name
find_package(GTest REQUIRED)

add_executable(test_$project_name
    test_main.cpp
)

target_link_libraries(test_$project_name
    PRIVATE
        $project_name
        GTest::gtest
        GTest::gtest_main
)

add_test(NAME "$project_name"_tests COMMAND test_"$project_name")
" > "$project_name/test/CMakeLists.txt"

    # CMakeLists.txt для примеров
    echo "\
# Примеры использования $project_name
add_executable(example_basic basic.cpp)
target_link_libraries(example_basic PRIVATE $project_name)
" > "$project_name/examples/CMakeLists.txt"
end

function _create_gitignore
    set project_name $argv[1]
    
    echo "\
# Сборки
build*/
*out/
*_build/

# IDE
.vscode/
.idea/
*.swp
*.swo
*~

# Скомпилированные файлы
*.o
*.so
*.a
*.dylib
*.exe

# CMake
CMakeCache.txt
CMakeFiles/
cmake_install.cmake
Makefile
compile_commands.json

# macOS
.DS_Store

# vcpkg
vcpkg_installed/
" > "$project_name/.gitignore"
end

function _create_readme
    set project_name $argv[1]
    
    echo "\
# $project_name

Проект на C++ с использованием CMake.

## Сборка

\`\`\`bash
mkdir build && cd build
cmake .. -DCMAKE_BUILD_TYPE=Release
cmake --build .
\`\`\`

## Установка

\`\`\`bash
cd build
sudo cmake --install .
\`\`\`

## Запуск тестов

\`\`\`bash
cd build && ctest --output-on-failure
\`\`\`

## Структура

- \`src/\` — исходный код библиотеки
- \`include/\` — заголовочные файлы
- \`test/\` — unit-тесты
- \`examples/\` — примеры использования
- \`extern/\` — внешние зависимости
" > "$project_name/README.md"
end

function _create_example_files
    set project_name $argv[1]
    
    # Создаем папку для заголовков
    mkdir -p "$project_name/include/$project_name"
    
    # Основной заголовочный файл
    echo "\
#pragma once

#include <string>

namespace $project_name {

/**
 * @brief Пример класса библиотеки
 */
class Library {
public:
    /**
     * @brief Конструктор
     */
    Library(const std::string& name);

    /**
     * @brief Возвращает приветствие
     */
    std::string greet() const;

private:
    std::string name_;
};

} // namespace $project_name
" > "$project_name/include/$project_name/lib.hpp"

    # Реализация
    echo "\
#include \"$project_name/lib.hpp\"

namespace $project_name {

Library::Library(const std::string& name) : name_(name) {}

std::string Library::greet() const {
    return \"Hello from \" + name_ + \"!\";
}

} // namespace $project_name
" > "$project_name/src/lib.cpp"

    # Тест
    echo "\
#include <gtest/gtest.h>
#include \"$project_name/lib.hpp\"

TEST(LibraryTest, GreetTest) {
    $project_name::Library lib(\"TestLibrary\");
    EXPECT_EQ(lib.greet(), \"Hello from TestLibrary!\");
}

TEST(LibraryTest, ConstructorTest) {
    $project_name::Library lib(\"AnotherName\");
    EXPECT_EQ(lib.greet(), \"Hello from AnotherName!\");
}
" > "$project_name/test/test_main.cpp"

    # Пример
    echo "\
#include <iostream>
#include \"$project_name/lib.hpp\"

int main() {
    $project_name::Library lib(\"ExampleApp\");
    std::cout << lib.greet() << std::endl;
    return 0;
}
" > "$project_name/examples/basic.cpp"
end
