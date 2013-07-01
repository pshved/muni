require 'muni/base'
require 'muni/prediction'

module Muni
  class Stop < Base
    def predictions
      stop = Stop.send(:fetch, :predictions, r: route_tag, d: direction, s: tag)
      available_predictions(stop).collect do |pred|
        Prediction.new(pred)
      end
    end

    def predictions_for_all_routes
      stop = Stop.send(:fetch, :predictions, stopId: stopId)
      available_predictions_for_all_routes(stop).inject({}) do |acc, (k,v)|
        acc[k] = v.map {|pred| Prediction.new(pred)}
        acc
      end
    end

    private

    def available_predictions_for_all_routes(stop)
      # Check that we got XML that is not an error.
      return [] unless  stop && stop['predictions']
      # Find all directions matching the title we requested.
      raw_predictions = {}
      stop['predictions'].each do |pred|
        raw_predictions[pred['routeTitle']] = (pred['direction'] || []).collect do |dir|
          dir['prediction']
        end.flatten
      end
      raw_predictions
    end

    private

    def available_predictions(stop)
      # Check that we got XML that is not an error.
      return [] unless  stop && stop['predictions']
      # Find all directions matching the title we requested.
      directions = []
      directions.push((stop['predictions'].first['direction'] || []).find do |dir|
        # Take all if direction is not specified, or pick the matching one.
        direction_title.nil? or dir['title'] == direction_title
      end).compact
      # Collect predictions from all the matching directions.
      directions.collect {|dir| dir['prediction']}.flatten
    end

  end
end
