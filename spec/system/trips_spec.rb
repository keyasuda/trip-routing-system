# frozen_string_literal: true

require 'system_helper'
# for debug with inspector/irb put page.driver.debug(binding)

RSpec.describe 'trips', type: :system, vcr: false do
  let(:existing_trips) { nil }

  before do
    existing_trips
    visit '/'
  end

  describe 'new trip' do
    let(:name) { 'new trip' }
    let(:description) { 'new description' }

    before do
      click_link 'add'

      fill_in 'trip_name', with: name
      fill_in 'trip_description', with: description
    end

    it 'has a fixed page title' do
      expect(page.title).to have_text(I18n.t('view.title.add', name: Trip.model_name.human))
    end

    describe 'add' do
      before do
        click_button 'done'
        sleep 1
      end

      it 'shows toast' do
        expect(page).to have_text(I18n.t('view.toast.added', name: name))
      end

      it 'shows trip name' do
        expect(page).to have_text(name)
      end

      it 'shows trip name as a page title' do
        expect(page.title).to have_text(name)
      end

      it 'shows trip description' do
        expect(page).to have_text(description)
      end

      describe 'modify the trip' do
        let(:new_name) { 'modified trip' }

        before do
          click_link 'settings'

          fill_in 'trip_name', with: new_name
          sleep 1
        end

        it 'shows current title as a page title' do
          expect(page.title).to have_text(name)
        end

        describe 'after submit' do
          before do
            click_button 'done'
          end

          it 'shows modified name' do
            expect(page).to have_text(new_name)
          end

          it 'shows toast' do
            expect(page).to have_text(I18n.t('view.toast.updated', name: new_name))
          end
        end
      end

      describe 'destroy the trip' do
        before do
          click_link 'settings'
          click_button 'delete'
        end

        it 'shows toast' do
          expect(page).to have_text(I18n.t('view.toast.destroyed', name: name))
        end
      end
    end
  end

  describe 'trip list' do
    describe 'blank trip' do
      let(:existing_trips) { FactoryBot.create(:trip) }

      it 'shows the name' do
        expect(page).to have_text(existing_trips.name)
      end
    end

    describe 'single day trip' do
      let(:existing_trips) { FactoryBot.create(:single_day_trip) }

      it'shows the name' do
        expect(page).to have_text(existing_trips.name)
      end

      it 'shows 1st day date' do
        expect(page).to have_text('2022-01-01 - 2022-01-01')
      end
    end

    describe 'two days trip' do
      let(:existing_trips) { FactoryBot.create(:two_days_trip) }

      it 'shows 1st day date' do
        expect(page).to have_text('2022-01-01 - 2022-01-02')
      end
    end

    describe 'three days trip' do
      let(:existing_trips) { FactoryBot.create(:three_days_trip) }

      it 'shows 1st day date' do
        expect(page).to have_text('2022-01-01 - 2022-01-03')
      end
    end

    describe 'trip order' do
      let(:trip1) { FactoryBot.create(:day20220101).trip }
      let(:trip2) { FactoryBot.create(:day20220102).trip }
      let(:trip3) { FactoryBot.create(:day20220103).trip }
      let(:existing_trips) { [trip1, trip2, trip3] }

      it 'shows 1/3 as a top' do
        expect(page.all('tr').first).to have_text('2022-01-03')
      end

      it 'shows 1/1 as a bottom' do
        expect(page.all('tr').last).to have_text('2022-01-01')
      end
    end
  end
end
