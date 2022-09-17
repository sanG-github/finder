class Folders::CreateService
  include PathHelper

  def initialize(path:, name: nil, without_parent: false)
    @path = path
    @name = name
    @without_parent = without_parent
  end

  def call
    check_valid_path!

    @path, @name = separate_path_and_name if name.blank?

    create_without_parent! if without_parent

    Folder.create!(path: path, name: name)
  end

  private

  attr_reader :path, :name, :without_parent

  def create_without_parent!
    folders_params = []

    path.split(SEPARATOR).compact_blank.reduce(SEPARATOR) do |acc, ele|
      next if ele.blank?

      folders_params << { path: acc, name: ele }

      "#{acc}#{acc == SEPARATOR ? "" : SEPARATOR}#{ele}"
    end

    Folder.create(folders_params) if folders_params.any?
  end
end
