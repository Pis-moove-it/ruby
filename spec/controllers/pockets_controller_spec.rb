require 'rails_helper'

RSpec.describe PocketsController, type: :controller do
  let(:json_response) { JSON.parse(response.body, symbolize_names: true) }

  let!(:organization) { create(:organization) }
  let!(:user) { create(:user, organization: organization) }
  let!(:route) { create(:route, user: user) }
  let!(:collection_point) { create(:collection_point) }
  let!(:collection) { create(:collection, route: route, collection_point: collection_point) }
  let!(:organization) { create(:organization) }

  let(:serializer) { PocketSerializer }

  describe 'GET #index' do
    def list_pockets_call
      get :index
    end

    context 'when the user is authenticated' do
      let!(:another_organization) { create(:organization) }
      let!(:another_user) { create(:user, organization: another_organization) }
      let!(:another_route) { create(:route, user: another_user) }
      let!(:collection_point) { create(:collection_point) }
      let!(:another_collection) do
        create(:collection, route: another_route, collection_point: collection_point)
      end

      let!(:auth_user) { create_an_authenticated_user_with(organization, '1', 'android') }

      let!(:unclassified_pocket) do
        create(:unclassified_pocket, organization: organization, collection: collection)
      end
      let!(:classified_pocket) do
        create(:classified_pocket, organization: organization, collection: collection)
      end
      let!(:another_unclassified_pocket) do
        create(:unclassified_pocket, organization: another_organization,
                                     collection: another_collection)
      end

      before(:each) { list_pockets_call }

      it 'does return success' do
        expect(response).to have_http_status(200)
      end

      it 'does return all the unclassified pockets' do
        expect(json_response).to eql [serializer.new(unclassified_pocket).as_json]
      end

      it 'does not return the classfied pockets' do
        expect(json_response.pluck(:id)).not_to include classified_pocket.id
      end

      it 'does not return the pockets from another organization' do
        expect(json_response.pluck(:id)).not_to include another_unclassified_pocket.id
      end
    end

    context 'when the user is not authenticated' do
      before(:each) { list_pockets_call }

      it 'does return an error' do
        expect(response).to have_http_status(401)
      end

      it 'does render the right error' do
        expect(json_response[:error_code]).to eql 2
      end
    end
  end
end