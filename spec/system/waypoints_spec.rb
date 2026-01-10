# frozen_string_literal: true

require 'system_helper'
# for debug with inspector/irb put page.driver.debug(binding)

RSpec.describe 'waypoints' do
  let(:day) { create(:day20220101) }
  let(:trip) { day.trip }

  before do
    visit "/trips/#{day.trip.id}/days/#{day.id}"
  end

  describe 'new waypoint' do
    before do
      click_link 'add'
      sleep 1
    end

    it 'has "スポットの追加" in the page title' do
      expect(page.title).to have_text(I18n.t('view.title.add', name: Waypoint.model_name.human))
    end

    it 'has day name in the title' do
      expect(page.title).to have_text(day.name)
    end

    it 'has trip name in the title' do
      expect(page.title).to have_text(trip.name)
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
        expect(page.find_by_id('waypoint-name').value).to include('神戸空港')
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
          before do
            click_link 'edit'
            sleep 1
          end

          it 'has the waypoint name in the page title' do
            expect(page.title).to have_text(name)
          end

          it 'has "の編集" in the page title' do
            expect(page.title).to have_text('の編集')
          end

          it 'has the day name in the page title' do
            expect(page.title).to have_text(day.name)
          end

          it 'has the trip name in the page title' do
            expect(page.title).to have_text(trip.name)
          end

          describe 'update' do
            let(:new_name) { 'new waypoint' }

            before do
              fill_in 'waypoint-name', with: new_name
              click_button 'done'
            end

            it 'updates it' do
              expect(page).to have_text(new_name)
            end
          end
        end

        describe 'destroy' do
          before do
            click_link 'edit'
            click_button 'delete'
            sleep 1
          end

          it 'shows toast' do
            expect(page).to have_text(I18n.t('view.toast.destroyed', name:))
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
        expect(page.find_by_id('waypoint-name').value).to include(f)
      end
    end
  end
end
