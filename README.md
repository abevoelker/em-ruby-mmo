# em-ruby-mmo

[Ruby MMO][1] converted to an EventMachine client-server protocol.

## Status

Proof-of-concept at the moment.

Basic player join/leave and PLAYERLIST query working. Next will be
the game start when players are ready, and notifying players that it's
their turn.  Players should be given a limited amount of time to
complete their turn (a couple seconds?).

## License

The code I write is licensed under the MIT license. Any code carried over
from the Ruby MMO project is copyright the respective author.

[1]: https://github.com/reedlaw/ruby-mmo
