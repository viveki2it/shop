class Dm::CategoriesController < ApplicationController
  layout 'dm'

  def index
    if params[:first_letter]
      @categories = Category.where("lower(name) SIMILAR TO ?" , params[:first_letter] + '%').order("LOWER(categories.name) ASC")
    else
      @categories = Category.order("LOWER(categories.name) ASC")
    end
    @mcs = MasterCategory.all.unshift(MasterCategory.new)
  end

  def update
    Category.all.each do |rc|
      if params[rc.name]
        mc = nil
        if params[rc.name][:master_category] != ""
           mc = MasterCategory.find(params[rc.name][:master_category])
        end
        rc.master_category = mc
        rc.save
      end
    end

    redirect_to dm_categories_path

  end


  def choose
    @letters = ('a'..'z').to_a
  end
end
