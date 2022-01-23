# frozen_string_literal: true

require 'system_helper'
# for debug with inspector/irb put page.driver.debug(binding)

RSpec.describe 'days', type: :system do
  describe 'new day' do
    let(:trip) { FactoryBot.create(:blank_trip) }
    let(:name) { 'new day' }
    let(:description) { 'day description' }

    before do
      visit "/trips/#{trip.id}"
      click_link 'add'

      fill_in 'day_name', with: name
      fill_in 'day_description', with: description
      click_button 'done'
    end

    it 'shows toast' do
      expect(page).to have_text('Day was successfully created.')
    end

    it 'shows day name' do
      expect(page).to have_text(name)
    end

    it 'shows day description' do
      expect(page).to have_text(description)
    end

    describe 'day settings' do
      before do
        click_link name
        click_link 'settings'
      end

      describe 'modify the day' do
        let(:new_name) { 'modified day' }

        before do
          fill_in 'day_name', with: new_name
          click_button 'done'
        end

        it 'shows modified name' do
          expect(page).to have_text(new_name)
        end
      end

      describe 'destroy the day' do
        before do
          click_button 'delete'
        end

        it 'shows toast' do
          expect(page).to have_text('Day was successfully destroyed.')
        end
      end
    end
  end

  describe 'routing' do
    let(:day) { FactoryBot.create(:unoptimized_day) }

    before do
      visit "/trips/#{day.trip.id}/days/#{day.id}"
    end

    it 'shows original route order' do
      expect(page.all('.active.day .waypoint .body div').map(&:text).join).to eq '012345'
    end

    describe 'optimization' do
      before do
        click_button 'auto_fix_normal'
        sleep 1
      end

      it 'shows optimized route order' do
        expect(page.all('.active.day .waypoint .body div').map(&:text).join).to eq '014325'
      end
    end
  end
end
