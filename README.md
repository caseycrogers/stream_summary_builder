# stream_summary_builder

Stream Summary Builder is an implementation of `StreamBuilderBase` that folds new stream
events into a summary type and builds the most up to date summary using the specified
builder.

Use this class instead of `StreamBuilder` if your stream produces a series of new elements
instead of a series of replacement elements. For example, you could use `StreamSummaryBuilder`
to aggregate results from a paginated database query.

Disclaimer: I have no idea what I'm doing and this package isn't unit tested. Use at your own risk.
Any contributions to this package are highly welcome.

## Getting Started

See `example/lib/main.dart`