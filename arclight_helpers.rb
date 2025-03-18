def process_file_operations(operations)
  operations.each do |operation, actions|
    actions.each do |action|
      puts "Processing #{operation} for #{action["file"]}"
      case operation
      when "append"
        append_to_file action["file"], action["text"]
      when "copy"
        copy_file File.join(__dir__, action["file"]), action["to"]
      when "create"
        create_file action["file"] do
          action["text"]
        end
      when "insert"
        insert_into_file action["file"], after: action["after"] do
          action["text"]
        end
      when "remove"
        remove_file action
      when "replace"
        gsub_file action["file"], /#{action["from"]}/, action["to"]
      end
    end
  end
end
