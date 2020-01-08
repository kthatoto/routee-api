class String
  def date_string?
    !!Date.parse(self)
  rescue
    false
  end
end
