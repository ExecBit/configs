function test-use-fish --description "Создать новый C++ проект с CMake"
    set project_name $argv[1]
    
    echo "\
cmake_minimum_required(VERSION 3.20)
project($project_name VERSION 1.0.0 LANGUAGES CXX)

set(CMAKE_CXX_STANDARD 20)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

add_executable($project_name src/main.cpp)
target_include_directories($project_name PRIVATE include)" > "$project_name/CMakeLists.txt"
    
    echo "Файл CMakeLists.txt создан"

end

