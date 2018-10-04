class PocketsController < AuthenticateController
  skip_before_action :authenticated_user, only: :edit_serial_number

  def index
    render json: Pocket.unclassified.where(organization_id: logged_user.organization.id)
  end

  def edit_serial_number
    pocket = Pocket.find(params[:id])
    return render_error(1, 'Missing serial number') if check_entry

    pocket.update!(serial_number: params['serial_number'])
    render json: pocket
  end

  private

  def check_entry
    params['serial_number'].nil? || params['serial_number'].blank?
  end
end
