#!/bin/bash

# Exit immediately if a command exits with a non-zero status.
set -e

# Define your base package path
BASE_DIR="lib/features/"

# Define your list of features
FEATURES=("home")  # Replace with your actual feature names

# Define the directory structure for each feature
DIR_STRUCTURE=(
  "data/datasources"
  "data/repositories"
  "data/models"
  "domain/entities"
  "domain/repositories"
  "domain/usecases"
  "presentation/views"
  "presentation/widgets"
  "presentation/blocs"  # or cubits/controllers based on your state management
)

# Function to create directories and Dart files for a single feature
create_directories_for_feature() {
  local feature=$1
  echo "Setting up directories for feature: $feature"

  for dir in "${DIR_STRUCTURE[@]}"; do
    local full_path="$BASE_DIR/$feature/$dir"
    mkdir -p "$full_path"
    echo "  Created directory: $full_path"

    # Generate specific Dart files based on directory type
    case $dir in
      "data/datasources")
        create_dart_file "$full_path/${feature}_data_source.dart" "abstract class ${feature^}DataSource {}"
        ;;
      "data/repositories")
        create_dart_file "$full_path/${feature}_repository_impl.dart" \
          "import '../../domain/repositories/${feature}_repository.dart';\n\nclass ${feature^}RepositoryImpl implements ${feature^}Repository {}"
        ;;
      "domain/repositories")
        create_dart_file "$full_path/${feature}_repository.dart" "abstract class ${feature^}Repository {}"
        ;;
      "presentation/blocs")
        create_dart_file "$full_path/${feature}_state.dart" \
          "class ${feature^}State {}"

        create_dart_file "$full_path/${feature}_cubit.dart" \
          "import 'package:flutter_bloc/flutter_bloc.dart';\nimport '${feature}_state.dart';\n\nclass ${feature^}Cubit extends Cubit<${feature^}State> {\n  ${feature^}Cubit() : super(${feature^}State());\n}"
        ;;
      "presentation/widgets")
        create_dart_file "$full_path/${feature}_widget.dart" \
          "import 'package:flutter/material.dart';\n\nclass ${feature^}Widget extends StatelessWidget {\n  @override\n  Widget build(BuildContext context) {\n    return Container();\n  }\n}"
        ;;
    esac
  done
}

# Helper function to create a Dart file with template content
create_dart_file() {
  local file_path=$1
  local content=$2

  if [[ ! -f $file_path ]]; then
    echo -e "$content" > "$file_path"
    echo "    Created Dart file: $file_path"
  else
    echo "    Dart file already exists: $file_path"
  fi
}

# Iterate over each feature and create directories and files
for feature in "${FEATURES[@]}"; do
  create_directories_for_feature "$feature"
done

echo "All feature directories and Dart files have been set up successfully."
