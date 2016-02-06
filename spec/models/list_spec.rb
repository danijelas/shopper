describe List, type: :model do
  context 'validations' do
    it { should validate_presence_of(:name) }
    it { expect(create(:list)).to validate_uniqueness_of(:name).scoped_to(:user_id).case_insensitive }
  end

  context 'association' do
    it { should belong_to(:user)}
    it { should have_many(:items).dependent(:destroy) }
    it { should accept_nested_attributes_for(:items).allow_destroy(true) }
  end

  describe 'total_sum' do
    it 'returns sum of all items sums if item attribute done is set to true' do
      list = create(:list)
      create(:item, qty: 2.5, price: 4, list: list, done: true)
      create(:item, qty: 1.5, price: 3, list: list, done: true)
      create(:item, qty: 0, price: 3, list: list)
      create(:item, qty: 1.5, price: 0, list: list)
      expect(list.total_sum).to eq(14.5)
    end
  end  

end
