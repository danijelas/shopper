describe Category, type: :model do

  context 'association' do
    it { should belong_to(:user)}
    it { should have_many(:items)}
  end

  context 'validations' do
    it { should validate_presence_of(:name) }
    it { expect(create(:category)).to validate_uniqueness_of(:name).scoped_to(:user_id).case_insensitive }
  end

  describe 'check_for_items' do
    it 'should check if there is any item' do
      user = create(:user)
      list = create(:list, user: user)
      category = user.categories[0]
      item = create(:item, list: list, category: category)
      category.destroy
      expect(category.errors).not_to be_empty
      expect(category.destroyed?).to be_falsy
    end
  end
end
