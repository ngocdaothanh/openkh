class DictsController < ApplicationController
  DICTS = [DictJaEn, DictJaVi]

  def search
    dict = params[:dict].to_i
    if dict >= 0 && dict < DICTS.size
      @results = DICTS[dict].search(params[:keyword], :order => :entry)
    else
      render(:text => '')
    end
  end

  def show

  end
end
