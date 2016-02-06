describe User, type: :model do
  context 'validations' do
    it { should validate_presence_of(:email) }
    it { should validate_presence_of(:first_name) }
    it { should validate_presence_of(:last_name) }
    it { should validate_presence_of(:currency) }
  end

  context 'association' do
    it { should have_many(:lists).dependent(:destroy) }
    it { should have_many(:categories).dependent(:destroy) }
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
        # user.categories.map{|c| c.name }
        # user.categories.map{|c| {id: c.id, name: c.name} }
        # [
        #   {id: 1, name: 'Name'},
        #   {id: 2, name: 'Name2'}
        # ]
        # a = []
        # user.categories.each do |c|
        #   a << c.name
        # end
    end
  end

end
