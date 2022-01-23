# frozen_string_literal: true

require 'system_helper'
# for debug with inspector/irb put page.driver.debug(binding)

RSpec.describe 'waypoints', type: :system do
  let(:day) { FactoryBot.create(:day20220101) }

  before do
    visit "/trips/#{day.trip.id}/days/#{day.id}"
  end

  describe 'new waypoint' do
    before do
      click_link 'add'
    end

    describe 'plus code search' do
      before do
        fill_in 'q', with: 'J6PF+4X 神戸市、兵庫県'
        click_button 'search'
        sleep 1
      end

      it 'shows one search result' do
        expect(page.find('.pois>li')).to have_text('神戸空港')
      end

      it 'fills name by search result' do
        expect(page.find('#waypoint-name').value).to include('神戸空港')
      end

      describe 'create' do
        let(:name) { 'new waypoint' }

        before do
          fill_in 'waypoint-name', with: name
          click_button 'done'
        end

        it 'adds new waypoint' do
          expect(page).to have_text(name)
        end

        describe 'copy' do
          before do
            click_button 'content_copy'
          end

          it 'copies it' do
            expect(page.all('li.waypoint').size).to eq 2
          end
        end

        describe 'edit' do
          let(:new_name) { 'new waypoint' }

          before do
            click_link 'edit'
            fill_in 'waypoint-name', with: new_name
            click_button 'done'
          end

          it 'updates it' do
            expect(page).to have_text(new_name)
          end
        end

        describe 'destroy' do
          before do
            click_link 'edit'
            click_button 'delete'
          end

          it 'shows toast' do
            expect(page).to have_text('Waypoint was successfully destroyed.')
          end

          it 'shows blank list' do
            expect(page.all('li.waypoint')).to be_blank
          end
        end
      end
    end

    describe 'keyword search' do
      before do
        fill_in 'q', with: '神戸空港'
        click_button 'search'
        sleep 1
      end

      it 'shows search results' do
        expect(page.all('.pois>li')).to all(have_text('神戸空港'))
      end

      it 'fills name by first result' do
        f = page.all('.pois>li').first.text
        expect(page.find('#waypoint-name').value).to include(f)
      end
    end
  end
end
