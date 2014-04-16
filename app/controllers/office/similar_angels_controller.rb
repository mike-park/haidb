class Office::SimilarAngelsController < Office::ApplicationController
  def match_by_name
    scope = SimilarAngel.find_by_name
    @similar_angels = SimilarAngelDecorator.decorate_collection(scope.sort)
  end

  def match_by_email
    scope = SimilarAngel.find_by_email
    @similar_angels = SimilarAngelDecorator.decorate_collection(scope.sort)
  end

  def merge
    angel = MergeAngels.new(angels).invoke
    redirect_to url_for, notice: "Merged #{angel_ids} into #{angel.full_name}"
  end

  private

  def angels
    Angel.find(angel_ids)
  end

  def angel_ids
    params[:angel_ids].to_s.split(/,/).map(&:to_i)
  end
end