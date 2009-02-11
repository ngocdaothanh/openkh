class DictsController < ApplicationController
  DICTS = [DictJaEn, DictJaVi]

  layout nil

  def search
    dict = params[:dict].to_i
    if dict >= 0 && dict < DICTS.size
      @results = DICTS[dict].search_for_keyword(params[:keyword], :per_page => 5)
    else
      render(:text => '')
    end
  end
end
