#!/bin/bash
#set -x

NEW_GIT_VERSION=2.39.3
NEW_TAR_VERSION="1.35" 
NEW_GZIP_VERSION="1.13"

# Default Dockerfile path
DOCKERFILE_PATH="${1:-Dockerfile}"

# Function to show current ARG values
show_current_args() {
    echo "Current ARG values in $DOCKERFILE_PATH:"
    grep -n "^ARG.*_VERSION=" "$DOCKERFILE_PATH" || echo "No ARG version lines found"
    echo
}

# Function to update ARG value
update_arg() {
    local arg_name="$1"
    local new_value="$2"
    local temp_file=$(mktemp)
    
    # Check if ARG exists
    if grep -q "^ARG ${arg_name}=" "$DOCKERFILE_PATH"; then
        # Get current value
        local current_value=$(grep "^ARG ${arg_name}=" "$DOCKERFILE_PATH" | cut -d'"' -f2)
        
        if [ "$current_value" = "$new_value" ]; then
            echo "${arg_name} is already set to '$new_value'"
            return 0
        fi
        
        # Update the ARG line
        sed "s/^ARG ${arg_name}=.*/ARG ${arg_name}=\"${new_value}\"/" "$DOCKERFILE_PATH" > "$temp_file"
        
        if [ $? -eq 0 ]; then
            mv "$temp_file" "$DOCKERFILE_PATH"
            echo "Updated ${arg_name}: '$current_value' → '$new_value'"
        else
            echo "Failed to update ${arg_name}"
            rm -f "$temp_file"
            return 1
        fi
    else
        echo "ARG ${arg_name} not found in Dockerfile"
        rm -f "$temp_file"
        return 1
    fi
}

# Main function
main() {
    echo "Updating JDK dependencies..."

    # Check if Dockerfile exists
    if [ ! -f "$DOCKERFILE_PATH" ]; then
        echo "Dockerfile not found at: $DOCKERFILE_PATH"
        exit 1
    fi
    
    echo "Before updating, current ARG values:"
    show_current_args

    update_arg "GIT_VERSION" "$NEW_GIT_VERSION"

    echo "After updating, current ARG values:"
    show_current_args

}


# Run main function
main