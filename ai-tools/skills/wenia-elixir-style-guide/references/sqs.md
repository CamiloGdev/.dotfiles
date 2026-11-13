# SQS: Broadway SQS consumers

| ID | Level | Rule | enforced_by |
|---|---|---|---|
| SQS-1 | Must | Start the consumer under the application supervisor (ARCH-11). Read queue, producer, processor, batcher, concurrency and retry/DLQ settings from validated config owned by the consumer (DATA-10, DATA-11). Don't copy concurrency or batch values from another consumer. | review |
| SQS-2 | Must | Mark every Broadway callback with `@impl Broadway`. Keep `%Broadway.Message{}` and SQS details out of the domain (ARCH-7). | compiler, credo:ImplTrue (enable), review |
| SQS-3 | Must | In `prepare_messages/2`, decode, validate the envelope and build domain input. Mark invalid input with `Message.failed/2`; never raise for validation (ERR-9). | review |
| SQS-4 | Must | Every callback returns every message it received. Later clauses require `status: :ok` and pass the others through. | review |
| SQS-5 | Must | A message stays `:ok` only after its required side effects and replies have completed. | review |
| SQS-6 | Must | Micro-batch only for a real advantage: bulk APIs, shared state, per-aggregate ordering, coalescing, or cheaper acks. Looping in `handle_batch/4` isn't micro-batching. Preserve cardinality and order, and don't fail a whole batch for one expected rejection. | review |
| SQS-7 | Must | FIFO: request `:message_group_id`, and derive `partition_by` and the batch key from the same stable ordering key. Fail missing FIFO metadata instead of falling back to a common key. | review |
| SQS-8 | Must | Classify outcomes. Poison input is recorded and deleted or sent to the DLQ. An expected business rejection is replied to and acked. A transient failure is failed for redelivery. An unexpected exception is left for Broadway to mark failed. Use `Message.configure_ack/2` for any other policy. | review |
| SQS-9 | Must | Visibility timeout > batch timeout + worst-case processing + reply time. | review |
| SQS-10 | Must | Processing is idempotent under redelivery: claim before acting and ack duplicates (ARCH-14). Don't spawn a task per message (ARCH-13). | review |
