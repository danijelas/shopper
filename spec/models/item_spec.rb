describe Item, type: :model do
  context 'validations' do
    it { should validate_presence_of(:name) }
    it { expect(create(:item)).to validate_uniqueness_of(:name).scoped_to(:list_id).case_insensitive }
    it { expect(subject).to validate_inclusion_of(:unit).in_array(%w[kg l m pic something]) }
  end

  context 'association' do
    it { should belong_to(:list)}
    it { should belong_to(:category)}
  end

  describe 'item_sum' do
    it 'returns price * qty if price and qty exist' do
      item = create(:item, qty: 2.5, price: 4)
      item1 = create(:item, qty: 0, price: 4)
      item2 = create(:item, qty: 2.5, price: 0)
      expect(item.item_sum).to eq(10)
      expect(item1.item_sum).to eq(0)
      expect(item2.item_sum).to eq(0)
    end
  end
  # describe 'set_currency' do
  #   it 'sets currency if currency is blank' do
  #     user = create(:user)
  #     list = create(:list, user: user)
  #     item = build(:item, list: list)
  #     expect(item.currency).to be_nil
  #     item.save
  #     expect(item.currency).to eq(user.currency)
  #   end
  # end
end