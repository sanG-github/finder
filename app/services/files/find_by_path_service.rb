class Files::FindByPathService < BaseService
  include PathHelper

  def initialize(path:)
    @path = path
  end

  def call
    path, name = separate_path_and_name

    Item.find_by_path_name!(path, name)
  end

  private

  attr_accessor :path, :name
end
