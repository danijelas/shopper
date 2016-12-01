describe User, type: :model do

  context 'association' do
    it { should have_many(:lists).dependent(:destroy) }
    it { should have_many(:categories).order(id: :asc).dependent(:destroy) }
  end

  context 'validations' do
    it { should validate_presence_of(:email) }
    it { should validate_presence_of(:first_name) }
    it { should validate_presence_of(:last_name) }
    it { should validate_presence_of(:currency) }
  end

  describe 'name' do
    it 'returns the concatenated first and last name' do
      user = create(:user, first_name: "First", last_name: "Last")
      expect(user.name).to eq 'First Last'
    end
  end

  describe 'populate_categories' do
    it 'adds categories to user' do
      user = create(:user)
      expect(user.categories.map(&:name)).to include("Dairy", "Bakery", "Fruits & Vegetables", "Meat", "Home Chemistry", "Miscellaneous")
    end
  end

end
