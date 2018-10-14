require 'rails_helper'

RSpec.describe Route, type: :model do
  let!(:organization) { create(:organization) }
  let!(:user) { create(:user, organization: organization) }
  let!(:route) { create(:route, user: user) }
  let(:r_serializer) { RouteSerializer }

  describe 'validations' do
    context 'when create routes with appropiate data' do
      it 'does let create new ones' do
        expect(route).to be_valid
      end
    end

    context 'when create routes with wrong values' do
      it 'does not let create new ones without user' do
        route.user = nil
        expect(route).not_to be_valid
      end
    end
  end

  describe 'serializer' do
    it 'does return routes, as specified in the serializer' do
      expect(r_serializer.new(route).attributes.keys).to eq %i[id length travel_image created_at]
    end
  end
end
