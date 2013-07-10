require 'action_view'

module Muni
  class Prediction < Base
    include ActionView::Helpers::DateHelper
    def time
      Time.at((epochTime.to_i / 1000.0).to_i)
    end

    def pretty_time
      if time > Time.now
        distance_of_time_in_words_to_now(time)
      elsif time < Time.now
        time_ago_in_words(time)
      else
        "Arriving"
      end
    end

    # Display time as if it was on a muni sign at a bus stop.
    def muni_time
      distance = time - Time.now
      if distance > 60
        "#{(distance / 60).to_i} min"
      elsif distance < -10
        # Not really useful.
        "#{((-distance) / 60).to_i} min ago"
      else
        # Finally!  It took that damn train like forever!
        "Arriving"
      end
    end
  end
end
