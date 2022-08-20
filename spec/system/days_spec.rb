# frozen_string_literal: true

require 'system_helper'
# for debug with inspector/irb put page.driver.debug(binding)

RSpec.describe 'days', type: :system do
  describe 'new day' do
    let(:trip) { create(:trip) }
    let(:name) { 'new day' }
    let(:description) { 'day description' }

    before do
      visit "/trips/#{trip.id}"
      click_link 'add'
      sleep 1
    end

    it 'shows 日程の追加 as a title' do
      expect(page.title).to have_text('日程の追加')
    end

    it 'shows the trip name in a title' do
      expect(page.title).to have_text(trip.name)
    end

    describe 'add' do
      before do
        fill_in 'day_name', with: name
        fill_in 'day_description', with: description
        click_button 'done'
      end

      it 'shows toast' do
        expect(page).to have_text(I18n.t('view.toast.added', name:))
      end

      it 'shows day name' do
        expect(page).to have_text(name)
      end

      it 'shows day description' do
        expect(page).to have_text(description)
      end

      describe 'day' do
        before do
          click_link name
          sleep 1
        end

        it 'has day name in a page title' do
          expect(page.title).to have_text(name)
        end

        it 'has trip name in a page title' do
          expect(page.title).to have_text(trip.name)
        end

        describe 'day settings' do
          before do
            click_link 'settings'
            sleep 1
          end

          it 'has day name in a page title' do
            expect(page.title).to have_text(name)
          end

          it 'has "の設定" in a page title' do
            expect(page.title).to have_text('の設定')
          end

          it 'has trip name in a page title' do
            expect(page.title).to have_text(trip.name)
          end

          describe 'modify the day' do
            let(:new_name) { 'modified day' }

            before do
              fill_in 'day_name', with: new_name
              click_button 'done'
              sleep 1
            end

            it 'shows modified name' do
              expect(page).to have_text(new_name)
            end

            it 'shows toast' do
              expect(page).to have_text(I18n.t('view.toast.updated', name: new_name))
            end
          end

          describe 'destroy the day' do
            before do
              click_button 'delete'
            end

            it 'shows toast' do
              expect(page).to have_text(I18n.t('view.toast.destroyed', name:))
            end
          end
        end
      end
    end
  end

  describe 'routing' do
    let(:day) { create(:unoptimized_day) }

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

  describe 'additonal day' do
    let(:day) { create(:day20220101) }

    before do
      visit "/trips/#{day.trip.id}"
      click_link 'add'
    end

    it 'shows the next date as default' do
      y = page.find('#day_start_at_1i').value
      m = page.find('#day_start_at_2i').value
      d = page.find('#day_start_at_3i').value
      h = page.find('#day_start_at_4i').value
      i = page.find('#day_start_at_5i').value
      actual = "#{y}-#{m}-#{d} #{h}:#{i}"

      expect(actual).to eq '2022-1-2 10:00'
    end
  end
end
