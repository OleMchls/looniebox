# Pull in Nerves-specific helpers to the IEx session
use Nerves.Runtime.Helpers

RingLogger.attach()

# Be careful when adding to this file. Nearly any error can crash the VM and
# cause a reboot.
