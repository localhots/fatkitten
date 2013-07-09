module Paste
  def get(params)
    table.where(params).first
  end

  def add(params)
    id = table.insert(params)
    return unless id.is_a?(Integer)

    get(id: id)
  end

  private

  def table
    DB[:pastes]
  end

  extend self
end
