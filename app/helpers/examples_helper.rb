module ExamplesHelper
  def delete_example?(example)
    example.is_author?(current_user) || example.phrase.is_author?(current_user)
  end
end
