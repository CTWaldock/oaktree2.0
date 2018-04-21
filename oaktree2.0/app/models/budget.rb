class Budget < ActiveRecord::Base
  belongs_to :user
  has_many :categories, :dependent => :destroy
  #destroy instead of delete_all as we want to trigger the callback on category to delete all expenses associated with said category
  has_many :expenses, :through => :categories
  validates :name, :limit, :start_date, :end_date, :categories, presence: true
  validate :end_cannot_come_before_start
  validates :limit, numericality: {greater_than: 0}
  scope :active, -> { where("start_date <= ? AND end_date > ?", Date.current, Date.current) }
  scope :inactive, -> { where("start_date > ?", Date.current) }
  scope :completed, -> { where("end_date <= ?", Date.current) }

  # custom nested params to ensure that users can edit category names properly through the budget update route or otherwise create a new category
  def categories_attributes=(attributes)
    attributes.each do |index, attribute|
      unless attribute[:title].blank? || self.categories.map(&:title).include?(attribute[:title])
        existing_category = self.categories[index.to_i]
        if existing_category == nil
          new_category = Category.create(title: attribute[:title])
          self.categories << new_category
        else
          existing_category.update(title: attribute[:title])
        end
      end
    end
  end

  def remaining_expense
    self.limit - self.total_expense
  end

  def exceeded?
    self.total_expense > self.limit
  end

  def average_expenditure
    if Date.current > self.end_date
      #completed budget
      self.total_expense / (self.end_date - self.start_date).to_i
    else
      #active budget
      # total expense / days passed, in case of first day, just behave as if 1 day has passed, i.e. show total expense
      Date.current > self.start_date ? self.total_expense / (Date.current - self.start_date).to_i : self.total_expense
    end
  end

  def recommended_expenditure
    if Date.current > self.start_date
      #active budget
      self.remaining_expense/self.remaining_days
    else
      #inactive budgets
      self.remaining_expense / (self.end_date - self.start_date).to_i
    end
  end

  def remaining_days
    (self.end_date - Date.current).to_i
  end

  def ordered_categories
    self.categories.order(:subtotal => :desc)
  end

  def top_five_expenses
    self.expenses.order(:cost => :desc).limit(5)
  end

  def most_recent_expenses
    self.expenses.order(:created_at => :desc).limit(5)
  end

  def status
    if self.start_date > Date.current
      "Inactive"
    elsif self.end_date <= Date.current
      "Complete"
    else
      "Active"
    end
  end

  private

  def end_cannot_come_before_start
    unless self.end_date == nil or self.start_date == nil
      errors.add(:end_date, "cannot come before start date") if self.end_date < self.start_date
    end
  end

end
