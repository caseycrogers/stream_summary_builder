# stream_summary_builder

An implementation of `StreamBuilderBase` that folds new stream events into a
summary and builds with the summary of stream events seen so far.
Use this class instead of `StreamBuilder` if you need a widget that
represents the summary of all stream event so far instead of just the latest
element. A common use case would be building a `ListView` with elements
fetched asynchronously from a paginated Database Query.

`T` is the type of stream events.

`S` is the type of interaction summary. Summaries are wrapped in `AsyncSnapshot` to give the builder access to the `ConnectionState`.
See also:
 * `StreamBuilder`, which is specialized for the case where only the most
   recent interaction is needed for widget building.
 * `StreamBuilderBase`, an abstract class that enables greater customization
   of summary and connection state behavior.

Disclaimer: I have no idea what I'm doing and this package isn't unit tested. Use at your own risk.
Any contributions to this package are highly welcome.

## Getting Started

See `example/lib/main.dart`