class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  # 指定されたカラム(attribute)に対して、検索方法(method)に応じたレコードを取得する
  #
  # @param attribute [String, Symbol] 検索対象のカラム名（例: "name" や "title"）
  # @param content [String] 検索するキーワード
  # @param method [String] 検索方法 ("perfect" | "forward" | "backward" | その他)
  # @return [ActiveRecord::Relation] 検索結果のレコード集合
  def self.search_by_attribute(attribute, content, method)
    unless [:name, :title].include?(attribute.to_sym)
      raise ArgumentError, "検索できるカラムは:nameまたは:titleのみです"
    end

    if method == 'perfect'
      # 完全一致の場合
      self.where(attribute => content)
    elsif method == 'forward'
      # 前方一致の場合
      self.where("#{attribute} LIKE ?", "#{content}%")
    elsif method == 'backward'
      # 後方一致の場合
      self.where("#{attribute} LIKE ?", "%#{content}")
    else
      # 部分一の場合
      self.where("#{attribute} LIKE ?", "%#{content}%")
    end
  end
end
