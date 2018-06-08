# frozen_string_literal: true

describe Rides::Import do
  describe '.call' do
    around do |example|
      Timecop.freeze '15.12.2017 13:00:00' do
        example.run
      end
    end
    # сабджект  - это объявление вызова тестируемого метода
    subject { described_class.call(csv_data) } 

    context 'with rides' do
      #тут готовим тестовые данные в файле
      let(:csv_data) {JSON.parse (File.read('/home/maxi4/Downloads/cash.json')) }
      #тут заполняем необходимые константы, которые подсунем в вызов действия
      let!(:employer) { create :employer, inn: '0274062111' }
      let!(:passenger) { create :passenger, employer: employer, pid: 1111 }
      let(:bus) { create :bus }
      let(:happened) { Time.now.in_time_zone('Europe/Moscow') }
      #тут как бы уже создаем экземпляр проверяемого класса. хм, но нам женадо проверить загрузку из файла 
      let!(:ride) { create :ride, happened_at: happened.to_s, bus_id: bus.id, passenger_id: passenger.id }
      #так и не понял, зачем инклюды
      include_examples 'returns success'
      include_examples 'does not create new', Passenger
      #вызов проверяемого метода
      subject
      #тут проверка результата проверяемого метода
      expect(Ride.last).passenger.id eq (1111)
    end
  end
end
