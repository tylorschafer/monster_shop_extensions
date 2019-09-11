require 'rails_helper'

describe 'welcome controller catch 404' do
  it "will render 404 for bad uri paths" do

    visit '/nuke9000'

    expect(page).to have_content("The page you were looking for doesn't exist")
  end
end
