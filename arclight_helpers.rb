def process_file_operations(operations)
  operations.each do |operation, actions|
    actions.each do |action|
      puts "Processing #{operation}"
      case operation
      when "append"
        action["text"].each do |text|
          append_to_file action["file"], text
        end
      when "copy"
        action["files"].each do |file|
          copy_file File.join(__dir__, "files", action["from"], file["file"]), file["to"]
          File.chmod(file["mode"].to_i(8), file["to"]) if file["mode"]
        end
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
