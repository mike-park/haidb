class Office::SimilarAngelsController < Office::ApplicationController
  def index
    if params[:by] == 'email'
      scope = SimilarAngel.find_by_email
      @find_method = 'email'
    else
      scope = SimilarAngel.find_by_name
      @find_method = 'name'
    end
    @similar_angels = SimilarAngelDecorator.decorate_collection(scope.sort)
  end

  def create
    if MergeAngels.new(angel_ids).invoke
      redirect_to office_similar_angels_path, notice: "Merge was successful"
    else
      redirect_to office_similar_angels_path, alert: "Merge was not completed"
    end
  end

  private

  def angel_ids
    params[:similar_angel] && params[:similar_angel][:angel_ids].split(/\s/).map(&:to_i)
  end
end