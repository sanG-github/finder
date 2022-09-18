class BaseService
  private

  def create_folder_without_parent!
    folders_params = []

    path.split(SEPARATOR).compact_blank.reduce(SEPARATOR) do |acc, ele|
      next if ele.blank?

      folders_params << { path: acc, name: ele }

      "#{acc}#{acc == SEPARATOR ? "" : SEPARATOR}#{ele}"
    end

    Folder.create(folders_params) if folders_params.any?
  end
end