function cmake-project-init --description "Создать новый C++ проект с CMake"
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
    mkdir -p "$project_name"/{src,test}
    
    echo "Создаю проект: $project_name"
    
    # Создаем основные файлы
    _create_cmake_lists "$project_name"
    _create_gitignore "$project_name"
    _create_example_files "$project_name"
    
    # Инициализируем git
    cd "$project_name"
    git init
    git add .
    git commit -m "Initial commit: $project_name"
    
    echo ""
    echo "✅ Проект '$project_name' успешно создан!"
    echo "📁 Переходим: cd $project_name"
end

function _create_cmake_lists
    set project_name $argv[1]
    
    echo "\
cmake_minimum_required(VERSION 3.10)
project($project_name)

set(CMAKE_CXX_STANDARD 20)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_CXX_EXTENSIONS OFF)

option(BUILD_TESTS \"Build tests\" OFF)
add_compile_options(-Wall -Wextra -Wpedantic -Werror)

add_executable("$project_name")

target_sources($project_name
    PRIVATE
        src/main.cpp
)

if(BUILD_TESTS)
    enable_testing()
    add_subdirectory(test)
endif()

" > "$project_name/CMakeLists.txt"

    # CMakeLists.txt для тестов
    echo "\
# Тесты для $project_name
find_package(GTest REQUIRED)

add_executable("$project_name"_tests
    test_main.cpp
)

target_link_libraries("$project_name"_tests
    PRIVATE
        GTest::gtest
        GTest::gtest_main
)

add_test(NAME "$project_name"_tests COMMAND "$project_name"_tests)
" > "$project_name/test/CMakeLists.txt"
end

function _create_gitignore
    set project_name $argv[1]
    
    echo "\
build*/
*out/
*_build/

.vscode/
.idea/
*.swp
*.swo
*~

*.o
*.so
*.a
*.dylib
*.exe
.cache/

CMakeCache.txt
CMakeFiles/
cmake_install.cmake
Makefile
compile_commands.json

.DS_Store

vcpkg_installed/
" > "$project_name/.gitignore"
end

function _create_example_files
    set project_name $argv[1]
    
    echo "\
#include <iostream>

int main() {
    std::cout << \"Hello world\" << std::endl;
    return 0;
}
" > "$project_name/src/main.cpp"


    echo "\
#include <gtest/gtest.h>

TEST(Test, GreetTest) {
    EXPECT_EQ(1, 1);
}
" > "$project_name/test/test_main.cpp"

end
