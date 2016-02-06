describe Category, type: :model do
  context 'validations' do
    it { should validate_presence_of(:name) }
  end

  context 'association' do
    it { should belong_to(:user)}
    it { should have_many(:items)}
  end
end
