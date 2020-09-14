References
----------
* Operating Systems [Course Link](https://classroom.udacity.com/courses/ud923)
* Google's Computer Networking Course: Beginner to Advanced [Video Link](https://youtu.be/QKfk7YFILws)


Introduction To Networking
==========================

TCP/IP Five-Layer Networking Model
----------------------------------

| # |  Layer Name |      Protocol     | Protocol Data Unit |  Addressing  |
|:-:|:-----------:|:-----------------:|:------------------:|:------------:|
| 5 | Application |  HTTP, SMTP, etc. |      Messages      |      n/a     |
| 4 |  Transport  |      TCP/UDP      |       Segment      | Port numbers |
| 3 |   Network   |         IP        |      Datagram      |  IP address  |
| 2 |  Data Link  |   Ethernet, WiFi  |       Frames       |  MAC address |
| 1 |   Physical  | 10 Base T, 802.11 |        Bits        |      n/a     |


1. *Physical layer* represents the physical devices that interconnects computers.

2. *Data link layer* (aka network interface/access layer) is responsible for defining a common way of interpreting these signals so network devices can communicate.
    - responsible for getting data across a single link

3. *Network layer* (aka internet layer) allows different networks to communicate with each other through devices known as routers.
    - a collection of networks connected together through routers is called an internetwork, the most famous of these being the Internet
    - responsible for getting data delivered across a collection of networks from one node to another

    _Network software is usually divided into client and server categories. A client application initiates a request for data and a server (or service) answers the request over the network. A single node may be running multiple client/server applications._

4. *Transport layer* sorts out which client and server programs are supposed to get the data.
    - responsible for getting data delivered across a collection of networks from one node to another, ensuring data gets to the right applications running on the nodes

5. *Application layer* is an abstraction layer that masks the rest of the application from the transmission process. It has various protocols which user applications can use for communication.


Basics of Networking Devices
----------------------------

1. *Cables* connect different devices to each other allowing data to be transmitted over them. Type of cables: Copper, Fiber.
    - Copper twisted-pair cables
        * Most common forms of Copper twisted-pair cables are _Cat5_, _Cat5e_ and _Cat6_ (these have different physical attributes).
        * _Cat5e_ have completely replaced _Cat5_ (category 5) to eliminate crosstalk.
        * electrical voltages are used to transmit pulses (0s and 1s)
    - Fiber optic cables
        * Contain individual optical fibers (which are tiny tubes made out of glass - about the width of human hair)
        * light is used to transmit pulses (0s and 1s)

    _Cables only allow point-to-point connections which doesn't generally fit the scale of networking devices in the real world._

2. *Hub* (layer 1 device)
    - allows all devices connected to hub to talk to all other devices
    - this creates a lot of noise on the network creating a collision domain (a network segment where only one device can communicate at a time)
    - therefore the devices have to wait for a quiet period before they try sending data again, which really slows down network communication

    Depiction of Hub as a symbol in networking diagrams:
    +-------+
    |       |
    | <---> |
    |       |
    +-------+

3. *Switch* (layer 2 device) aka Network Switch (originally known as Switched Hub)
    - significantly reduces collision domain as it has access to the ethernet data and can identify which system is the data intended for
    - reduced retransmissions and higher overall throughput

    _Hubs and switches are the primary devices used to connect computers on a single network, usually referred to as a LAN (local area network)._

    Depiction of Switch as a symbol in networking diagrams:
    +--------+
    | <--    |
    |    --> |
    | <--    |
    |    --> |
    +--------+

4. *Router* (layer 3 device)
    - a device that knows how to forward data between independent networks
    - can access IP data to know where to send things
    - store internal tables (known as routing tables) containing information on how to route traffic between lots of different networks all over the world

    _Routers share data with each other via a protocol known as BGP (Border Gateway Protocol) which lets them learn about most optimal paths to forward traffic._

    Depiction of Router as a symbol in networking diagrams:

      _ - - _
     -   ^    -
    -    |     -
    - --> <--  -
    -    |     -
     -   v    -
      - _ _ -


Physical Layer
--------------
* Line coding, a modulation technique, allows sending 10 billion ones or zeros every second over a network cable.
* Types of communication
    * Duplex (or Full duplex) - bidirectional communication
    * Simplex - unidirectional communication
    * Half duplex - bidirectional communication with the constraint that only one device can communicate at a time
* Endpoints of Network Links
    * Network ports: RJ45 plug/port is the most commonly used (RJ45 stands for Registered Jack 45). RJ45 port has 2 LEDs: Activity and Link. Link LED indicates if cable is properly connected between two powered on devices. Activity light flashes when data is actively transmitted over the cable.
    * Patch panels: contains many network ports and do not have any other function.

Data Link Layer
---------------
* Ethernet and MAC addresses
    * Ethernet uses CSMA/CD (Carrier Sense Multiple Access with Collision Detection) to solve the collision domain problem in a network segment.
    * MAC (Media Access Control) address is a globally unique identifier attached to an individual network interface (NIC).
        - 48-bit number represented by 6 groupings of 2 hex digits, eg. AA::BB::CC::DD::EE:FF.
        - First three octets refer to OUI (Organizationally Unique Identifier), which is assigned by IEEE to individual hardware manufacturers (like Cisco).
        - Last three octets are assigned by vendor with the condition that each address is assigned only once.

    _Octet: any number that can be represented by 8 bits (ie 2 hex digits or a decimal number from 0 to 255)._

* Unicast, Multicast, Broadcast
    * A unicast transmission is just meant for one receiving address.
        - Ethernet frame is intended only for `destMACAddr` if `(destMACAddr >> 40 & 1)` is 0 (ie if LSB of first octet of destination address is zero).

    _Unicast frame is sent to all devices in a collision domain but only actually received and processed by the intended destination._

    * multicast transmission is meant for multiple receiving addresses.
        - Multicast frame if `(destMACAddr >> 40 & 1)` is 1 and the address is not all `FF`s.

    _Multicast frame is also sent to all devices in a collision domain but the acceptance/rejection of frame is decided by a criteria aside from their hardware MAC addresses. Network interfaces can be configured to accept lists of multicast addresses for these sorts of communications._

    * broadcast transmission is meant for all receiving addresses on a LAN.
        - ethernet broadcast is used so that devices can learn more about each other.
        - achieved by using ethernet broadcast address FF:FF:FF:FF:FF:FF.

* Dissecting an Ethernet Frame

+---------------+------------------+-----------------+----------+----------------+-------------------+----------+
| preamble (8B) | destMACAddr (6B) | srcMacAddr (6B) | tag (4B) | etherType (2B) | payload (0-1500B) | FCS (4B) |
+---------------+------------------+-----------------+----------+----------------+-------------------+----------+

|<---------------------------------------H-------------------------------------->|<--------B-------->|<---T---->|

H: Header
B: Body
T: Trailer (or Footer)

FCS: frame check sequence (computed using CRC32, where CRC stands for Cyclic Redundancy Check)


Networking Layer
================

Introduction
------------
* IPv4 addresses
    - 32-bit numbers represented by 4 octets in dotted-decimal notation, eg. 192.168.1.1.

    _IP addresses belong to networks, not to the devices attached to those networks._

    - Dynamic IP Address (configured automatically using DHCP when connecting toa new network) and Static IP Addresses (configured manually). In most cases, static IPs are reserved for servers and network devices, while dynamic IPs are reserved for clients.

* Data packets at Networking layer are known as *IP Datagrams*.

* IP Datagram Header Format

    0                   1                   2                   3
    0 1 2 3 4 5 6 7 8 9 0 1 2 3 4 5 6 7 8 9 0 1 2 3 4 5 6 7 8 9 0 1
   +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
   |Version|  IHL  |Type of Service|          Total Length         |
   +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
   |         Identification        |Flags|      Fragment Offset    |
   +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
   |  Time to Live |    Protocol   |         Header Checksum       |
   +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
   |                       Source Address                          |
   +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
   |                    Destination Address                        |
   +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
   |                    Options                    |    Padding    |
   +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+


   _Version can signify IPv4 or IPv6_.

   _Since the Total Length field is 16-bit, the maximum size of datagram is 65535. If the total amount of data to be sent is larger than this, the IP layer needs to split this data into many individual packets (making use of the Identification field)._

   _TTL indicates Time To Live, that is, how many router hops a datagram can traverse before it is thrown away. (typical value 64)_

   _Protocol indicates what transport layer protocol is being used._

   _Source and Destination IP Address are both 32-bit long._

* Encapsulation

            +---------------+
            |    Message    |    (Application)
            +---------------+
        +---+---------------+
        | H3|    Message    |      (Transport)   H3: TCP/UDP Header;  Body: Application Message
        +---+---------------+
    +---+-------------------+
    | H2| TCP / UDP Message |        (Network)   H2: IP Header;       Body: TCP Segment or UDP Datagram
    +---+-------------------+
+---+-----------------------+---+
| H1|      IP Datagram      | F1|  (Data-Link)   H1: Ethernet Header; Body: IP Datagram; F1: Ethernet Footer
+---+-----------------------+---+

    _This explains why we think of in terms of layers / hierarchies for networking._


IPv4 Addressing
---------------

* Classful Addressing

In classful addressing, each IPv4 address has two parts: netid (identifies network) and hostid (identifies host).

| Class | Prefix | First Octet range |                 Uses                 |
|:-----:|:------:|:-----------------:|:------------------------------------:|
|   A   | 0      |      [0, 128)     |  Large #hosts = 2^(32 - 8); Unicast  |
|   B   | 10     |     [128, 192)    | Medium #hosts = 2^(32 - 16); Unicast |
|   C   | 110    |     [192, 224)    |  Small #hosts = 2^(32 - 24); Unicast |
|   D   | 1110   |     [224, 240)    |               Multicast              |
|   E   | 1111   |     [240, 256)    |     Unassigned (testing purposes)    |


_This class system has been replaced by a classless sytem called CIDR (Classless inter-domain routing)._

* ARP
    - Address Resolution Protocol (ARP) is used to discover the hardware address of a node with a certain IP address.
    - When an IP datagram has been formed and corresponding ethernet frame is to be created, the destination MAC address is needed. For this the ARP table on the node is looked up. An ARP table is just a list of IP address and the MAC addresses associated with them.
    If ARP table entry for destination IP is missing the node sends a broadcast ARP message to broadcast MAC address, which when received by the target node sends an ARP response (containing the target MAC address) back to the source. These entries are cached in table and expire after a short amount of time to ensure changes in the network are accounted for.

    _A *network interface* has two addresses - a layer 2 address (MAC address or hardware or physical or burned-in address) and a layer 3 address (the IP address v4 or v6). The IP address of NIC is, in most cases, a dynamic (private) IP assigned to NIC by DHCP (server or router)._

* Classless Addressing
    - Overcomes the problem of address depletion by granting addresses in variable-length blocks with the following conditions:
        * addresses should be contiguous in the block
        * block size should be a power of 2
        * first address should be divisible by block size
    - Represented as:
            `x.y.z.t/n`
        where `0 <= n <= 32` and `/n` is the CIDR notation defining the subnet mask
              and
              `x.y.z.t is` one of the address in the block


Subnetting
----------

_In a subnet, the actual number of host addresses are two less than the overall size of the address space. This is because the first IP address is not used and it identifies the network to the rest of the world. Also, the last IP address is typically reserved as a broadcast address for the subnet._


* Plain Subnetting (using subnetting in classful addressing)

_In classful addressing with subnetting, each IPv4 address has three parts: netid (identifies network), hostid (identifies host) and subnetid (identifies the subnet)._

```
netid    = ipAddr & classMask
subnetid = ipAddr & ~classMask & subnetMask
hostid   = ipAddr & ~subnetMask
```
    where classMask = `255.0.0.0` (for class A), `255.255.0.0` (for class B), `255.255.255.0` (for class C)
    (Class A, B or C can be identified on the basis of range of first octet of the IP address.)


* CIDR (Classless inter-domain routing)

_In CIDR, each IPv4 address has two parts: netid (identifies network) and hostid (identifies host), where netid and subnetid are coalesced into one._

```
netid  = ipAddr & subnetMask
hostid = ipAddr & ~subnetMask
```

Checking if IP belongs to subnet:
1) By calculating first and last IP in subnet:
```
uint32_t ip = ...; // value to check
uint32_t netip = ...; // network ip to compare with
uint32_t netmask = ...; // network ip subnet mask
uint32_t netstart = (netip & netmask); // first ip in subnet
uint32_t netend = (netstart | ~netmask); // last ip in subnet
if ((ip >= netstart) && (ip <= netend))
    // is in subnet range...
else
    // not in subnet range...
```
2) By using binary AND:
```
uint32_t ip = ...; // value to check
uint32_t netip = ...; // network ip to compare with
uint32_t netmask = ...; // network ip subnet mask
if ((netip & netmask) == (ip & netmask))
    // is on same subnet...
else
    // not on same subnet...
```

Routing
-------
* Router is a network device that forwards traffic depending on the destination address of the traffic.
* Router has at least 2 network interfaces as it connects multiple networks.
* Routing concepts:
    Routers inspect the packets' destination IP, look at their routing tables to determine which path is the quickest and forward the packets along the path.

_Routers are connected to many more than two networks. Your traffic may have to cross a dozen routers before it reaches its destination._

* Routing tables can vary significantly depending on the make of the router. Even so, a routing table will have the following four columns:
    - Destination network (a netid and a netmask - CIDR notation)
        - When a packet is received by the router it will check each entry in destination network column to see if destination IP belongs to that network. A routing table generally has a catch-all entry that matches any IP address that it does not have an explicit network listing for.
    - Next hop
        - Next hop is IP address of the next router that should receive data intended for the destination network. It can also signify that network is directly connected and there are no additional hops needed.
    - Total hops
        - Router has to keep track of how far away the destination currently is, that way when it receives information from neighboring routers it will know if a better path is available.
    - Interface
        - Router has to know which of its interfaces it should forward traffic matching its destination out of.

* Routing Protocols
    |
    +-- Interior Gateway Protocols
    |     (used by routers to share information within a single autonomous system ie with same network operator)
    |       |
    |       +-- Distance-Vector Protocols
    |       |       * involves sending a list of hops (ie a distance-vector) to every neighboring router
    |       |       * limitation of this approach is that information is shared only among neighbors and this
    |       |         system would be slow to react to changes in network far away from it.
    |       |
    |       +-- Link-State Routing Protocols
    |               * each router advertizes the state of the link of each its interfaces
    |               * hence, every router in the autonomous system knows about the detail of every other router
    |               * requires much more memory and processing power to be able to run shortest path algorithms
    |                 on this data
    |
    +-- Exterior Gateway Protocols
            - used to communicate data between routers representing the edges of the autonomous systems
            - getting data to these edge routers (representing independent autonomous systems) is the number one goal of the core internet routers
            - IANA manages IP address allocation and ASN allocation.
                * IP Address (32-bit) information is present in routing tables of all routers.
                * Autonomous System Number (32-bit) is present additionally in routing tables of the core internet routers. Eg. of autonomous systems: IBM, Airtel (an ISP).

Non-Routable Address Space
--------------------------

_There are only 2^32 IPv4 addresses possible, meaning there isn't even one IPv4 address available per person._

* Ranges of IPs set aside for use by anyone that cannot be routed to. No gateway router will attempt to forward traffic to this type of network. There is a technology called NAT (Network address translation) which allows computers on Non-Routable Address Space to communicate with the Internet.

* RFC 1918 (Request for Comments) defined three ranges of IPv4 addresses that will not be routed to by the core routers. That means they belong to no-one but anyone can use them.
    - `10.0.0.8/8`
    - `172.16.0.0/12`
    - `192.168.0.16/16`
These ranges are free for anyone to use in their internal networks. Interior gateway protocols will route these addresses but the Exterior gateway protocols will not.


ICMP
----
* Internet Control Message Protocol is a network layer protocol used by network devices to diagnose network communication issues.
* Involves sending of error-reporting and query messages.
* Diagnostic tools which use ICMP for debugging:
    * `ping` (Packet InterNet Groper)
        * Tests the reachability of host.
    * `traceroute`
        * Used to determine the path taken by packets from one IP address to another.
        * Elegantly uses TTL to find the route of a packet (first packet is sent with TTL of 1, second with TTL of 2, and so on, until the packet reaches the destination).


Transport Layer
===============

Introduction
------------
* Allows traffic to be directed to specific network applications.

* Functions
    - Multiplexing and demultiplexing traffic
    - Establishing long running connections
    - Ensuring data integrity through error checking and data verification

* Multiplexing in Transport Layer means that nodes on a network have the ability to direct traffic to many different receiving services. Demultiplexing means nodes on a network have the ability to take traffic that is directed to them and delivering it to the proper receiving service.

    _Transport layer handles multiplexing and demultiplexing through ports. A port is a 16-bit number that's used to direct traffic to specific services running on networked computer._

* Traditional HTTP (for unencrypted web traffic) uses port 80. For eg. `10.1.1.100:80` is the *socket address* to which the web traffic will be directed to if a client requests a webpage from that server.


TCP
---

* Dissection of TCP Segment Header

    0                   1                   2                   3
    0 1 2 3 4 5 6 7 8 9 0 1 2 3 4 5 6 7 8 9 0 1 2 3 4 5 6 7 8 9 0 1
   +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
   |          Source Port          |       Destination Port        |
   +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
   |                        Sequence Number                        |
   +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
   |                    Acknowledgment Number                      |
   +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
   |  Data |       |C|E|U|A|P|R|S|F|                               |
   | Offset| Rsrvd |W|C|R|C|S|S|Y|I|            Window             |
   |       |       |R|E|G|K|H|T|N|N|                               |
   +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
   |           Checksum            |         Urgent Pointer        |
   +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
   |                    Options                    |    Padding    |
   +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
   |                       data octets ...
   +-+-+-+-+-+-+-+-+-+-+-+-+-+-+- ...


   _Source port is a high-numbered port chosen from a special section of ports known as ephemeral ports._

   _Sequence Number is a 32-bit number that is used to keep track of where in sequence of TCP segments this one is expected to be._

   _Acknowledgement Number is the number of the next expected segment._

   _TCP Window specifies the range of sequence numbers that might be sent before an acknowledgement is required._

   _Urgent Pointer is used in conjunction with the URG control flag in TCP to point out particular segments are more important than others._


* TCP Control Flags

1. URG (urgent): a set value indicates that the segment is considered urgent and that urgent pointer has more data about this
2. ACK (acknowledged): a set value indicates that the acknowledgment number field should be examined
3. PSH (push): a set value indicates that transmitting device wants receiving device to push the currently buffered data to the application on receiving end ASAP
4. RST (reset): a set value indicates that one of the sides in TCP connection hasn't been able to properly recover from a series of missing or malformed segments
5. SYN (synchronize): a set value indicates that a TCP connection is being established and the sequence number field should be examined
6. FIN (finish): a set value indicates the transmitting computer doesn't have any more data to send and the connection can be closed


- TCP establishes connections to send long chains of segments of data.
- TCP connection establishment [3-way handshake]
    Tx ----- SYN -----> Rx
    Tx <--- SYN/ACK --- Rx
    Tx ----- ACK -----> Rx

- TCP connection teardown [4-way handshake]
    Tx ----- FIN -----> Rx
    Tx <---- ACK ------ Rx
    Tx <---- FIN ------ Rx
    Rx ----- ACK -----> Rx


* TCP Socket States
    _Socket is the instantiation of an end-point in a potential TCP connection._

1. LISTEN: a TCP socket is ready and listening for incoming connections (seen server-side)
2. SYN_SENT: a SYN request has been sent but the connection hasn't been established yet (seen client-side)
3. SYN_RECEIVED: a socket previously in LISTEN state has received a SYN request and sent a SYN/ACK back (seen server-side)
4. ESTABLISHED: the TCP connection is in working order and both sides are free to send each other data (seen both server-side and client-side)
5. FIN_WAIT: a FIN has been sent but the corresponding ACK from the other side hasn't been received yet (seen both server-side and client-side)
6. CLOSE_WAIT: the connection has been closed at the TCP layer but the application that opened the socket hasn't released its hold on the socket yet
7. CLOSED: the connection has been fully terminated and that no futher communication is possible

Other socket states may exist at the OS level but those are not in the scope of TCP (which is universal in the way it is used).

* Connection-oriented protocol is the one where a connection is established which is then used to ensure that all data has been properly transmitted. Eg. TCP. Use-case for connection-oriented protocols is WhatsApp Messaging.
    * Checksum mismatches at layers below the transport layer cause the data packet to be discarded. The scope of retransmissions is entirely at the TCP layer as it maintains sequence numbers and acknowledgment numbers which allow _flow and error control mechanisms_ to be employed.
    * At the same time there is a lot of overhead involved with connection-oriented protocols:
        - connection has to be established
        - constant stream of acknowledgments have to be sent
        - connection teardown has to happen
      which is important if the packet delivery is desired to be guaranteed.

* Connection-less protocol is a stateless protocol which involves sending data without ensuring that the other side is ready to use. Eg. UDP. Use-case for connection-less protocols is WhatsApp Video Calls.
    * For instance, while streaming a video (assume each frame of the video to be a datagram), even if some frames get lost along the way the video will still be watchable, besides, with UDP the video quality will be better compared to TCP as the available bandwidth would be used for actual data transmission rather than connection establishment/teardown or data segment acknowledgements.

UDP
---
* Dissection of UDP Datagram

      0      7 8     15 16    23 24    31
     +--------+--------+--------+--------+
     |     Source      |   Destination   |
     |      Port       |      Port       |
     +--------+--------+--------+--------+
     |                 |                 |
     |     Length      |    Checksum     |
     +--------+--------+--------+--------+
     |
     |          data octets ...
     +---------------- ...


Firewall
--------
* A firewall blocks (or filters) traffic that meets certain criteria.
* Firewalls can
    * inspect application layer traffic
    * block range of IP addresses
    * block incoming traffic on certain port numbers
* Firewalls can be
    * a program running on a host
    * a standalone network device
    * built into a router


Application Layer
=================

* Allows these applications to communicate in a way they understand.

* Example of web client/server software. They'll need to speak the same protocol for network communication.
    * Web browsers are clients: Google Chrome, Opera, Safari
    * Web servers are servers: Microsoft IIS, Apache, nginx
  For web traffic, the application layer protocol is known as HTTP. All of these web browsers and web servers have to communicate using the same HTTP protocol to ensure interoperability.

* Application layer and OSI model. There are two more layers between transport and application layer per OSI model:
    - Session layer: takes application layer data from transport layer and hands it over to presentation layer
    - Presentation layer: ensures unencapsulated application layer data is comprehensible by the application (ie this layer deals with encryption/decryption and/or compression/decompression).

* All layers in unison: https://www.youtube.com/watch?v=QKfk7YFILws&t=8687s



Network Services
================

DNS
---

* Domain Name System (DNS) is a global and highly distributed network service that resolves domain names into IP addresses.

_The further you've to route data, the slower the network communication becomes. In almost all situations, it is going to be quicker to transmit data between places that are geographically closer to each other._


* Things required for network configuration on a host:
    1. IP Address
    2. Subnet Mask
    3. Primary Gateway
    4. DNS Server

* Types of DNS Servers
    1. Caching name servers
    2. Recursive name servers
    3. Root name servers
    4. TLD (top-level domain) name servers
    5. Authoritative name servers

    * Caching and recursive name servers are generally provided by the ISP and used to store known domain lookups for a certain amount of time.

    * All domain names in the global DNS system have a TTL (which is a value in seconds that can be configured by the owner of domain name to specify how long a name server is allowed to cache the entry before discarding it and performing a full DNS resolution). As the internet has grown, the large values of TTL have gone down to few hours or minutes.

* Name Resolution: https://youtu.be/QKfk7YFILws?t=10042

* DNS uses UDP for 2 primary reasons:
    - A single DNS request and response can generally fit in a single UDP datagram packet, making it an ideal candidate for connectionless protocol.
    - DNS can generate a lot of traffic (even though there are caching systems) due to full DNS resolutions.

    _Using TCP for something as rudimentary as DNS would be an overkill and significantly slow. As far as error recovery is concerned, if DNS resolver doesn't get a response back it simply asks again, which means the same functionality which TCP provides at the transport layer is provided by DNS at the application layer._

    _Note that DNS over TCP also exists: as the internet has grown it may no longer be the case that DNS response will fit a UDP datagram. In this situation, DNS name server would respond with a packet explaining that the response is too long, after receipt of which the DNS client will establish a TCP connection to perform the lookip._


* Resource Records
    - A-Record
        - point a certain domain name to IPv4 address
        - a single domain name can have multiple A-records which can be used with DNS round-robin to balancing the traffic across different servers. For eg. if there are four A-records with IPs 10.1.1.0/30 and
            - DNS resolver on first client performs a lookup, it will get the four IPs in the order 0, 1, 2, 3.
            - DNS resolver on second client performs a lookup, it will get the four IPs in the order 1, 2, 3, 0.
    - AAAA-Record (Quad-A Record)
        - similar to A-Record but for IPv6
    - CNAME Record
        - redirect traffic from one domain to another. For eg. if AAPL runs their webservers on "www.apple.com" and want to ensure anyone who enters "apple.com" gets properly redirected, they can do so by creating a CNAME record for "apple.com" to make it resolve to "www.apple.com".
        - CNAME is useful for ensuring that you've to only change the IP address of the canonical name (since all other domain names redirect to the canonical name).
    - MX Record - mail exchange
    - SRV Record - service record (like calendar scheduling service)
    - TXT Record - text record
    - etc.

* Anatomy of a Domain Name
www.google.com
 |      |    |
 |      |    +-- TLD (Top-Level Domain)
 |      |           * last part of domain name
 |      |           * TLDs are managed by ICANN, sister org to IANA)
 |      |
 |      +------- domain
 |                  * used to demarcate where control moves from a TLD name server to an authoritative name server
 |                  * typically controlled by independent orgs outside of ICANN
 |                  * costs money to buy a domain from a registrar (registrar is a company that
 |                    has an agreement with ICANN to sell unregistered domain names)
 |
 +-------------- subdomain
                    * can be freely chosen by anyone who owns the domain

* When you combine all of these, you've what is called *FQDN* (Fully qualified domain name).
* FQDN is limited to a length of 255 characters with each section having upto 63 characters.

_DNS can technically support upto 127 levels of domain in a single FQDN._


* DNS Zones
- Allow for easier control over multiple levels of domain. For eg.
    * la.largecompany.com
    * de.largecompany.com
    * ch.largecompany.com
- Zone files are simple configuration files that declare all resource records for a particular zone.


DHCP
----
* An application layer protocol that automates the configuration process of hosts on a network.

* Things required for network configuration on a host:
    1. IP Address
    2. Subnet Mask
    3. Primary Gateway (IP Address of Router)
    4. DNS Server (IP Address of Name Server)
    Of these the last 3 will typically remain same while configuring multiple hosts on a network.
    However, for network communication, each host must be given a different IP which is tedious
    to do manually and is therefore managed by DHCP.

* DHCP Server may use one of the following methods for dynamic host configuration:
    - Dynamic Allocation
        - range of IPs is set aside for client devices and issues as and when they're requested
        - a host may get a different each time it reconnects to the network
    - Automatic Allocation
        - range of IPs is set aside for assignment which are kept track of
        - a host would be reassigned the same IP if possible when reconnecting to the network
    - Fixed Allocation
        - requires manually specified list of MAC addresses and their corresponding IPs


NAT
---

* Network Address Translation is a technique that allows a gateway, usually a router or firewall, to rewrite the source IP of an outgoing IP datagram while retaining the original IP in order to rewrite it into the response.

* A router with NAT connecting nodes A and B, hides IP of A from B. This is called *IP masquerading* which is an important security concept.
* In a similar way, hundreds of nodes in network A can have their IP translated to that of the router making the entire address space of A invisible to the rest of world. This is called *one-to-many NAT*. Port preservation can be used in the router for routing the responses received by it to the respective nodes in the network A.

* Port forwarding can be used for complete *IP masquerading*.


VPN
---

* Virtual Private Networks are a technology that allows for the extension of a private or local network to hosts that might not be on that local network.
* When a VPN connection is established using a remote client, the remote client provisions a virtual interface (encrypted VPN tunnel) with an IP that matches the address space of the remote network.

* Most VPNs work by using the payload section of the transport layer that contains an entire second set of packets intended to traverse the remote network. This process is completed in the inverse in the opposite direction.


Proxies
-------

* Proxy is a server that acts on behalf of a client in order to access another service.
* Proxies provide the following benefits:
    - Anonymity
    - Security
    - Content Filtering
    - Increased Performance

* Reverse Proxy is a service that might appear to be a single server to external clients but actually represents many servers living behind it.



Connecting to Internet
======================

* USENET
    * uses POTS (plain old telephone service) for data transfer
    * baud rate: 300 bps (phone line)
* Dial-up Connection
    * gets its name by the fact that connection is established by actually dialling a phone number
    * uses POTS for data transfer
    * uses modems
    * baud rate: 14.4 kbps (phone line)
* Broadband
    - refer to long lasting connections (need not be established with each use like dial-up)
    - major broadband technologies
        * T-carrier technologies
            - originally invented by AT&T to transmit multiple phone calls over a single link
            - data rate: 1.544 Mbps (T1 line)
        * DSL
            - digital subscriber line, also use modems aka DSLAM, could deliver data at much higher rates using the same phone line while operating at a different frequency range
            - unlike dial-up connections, these are long running connections
            - common types of DSL:
                - ADSL (asymmetric DSL) offered faster download speeds and slower upload speeds (client-side)
                - SDSL (symmetric DSL) offered same speeds for download and upload (server-side)
            - data rate: 1.544 Mbps
        * Cable broadband
            - coaxial cables with a different frequency range could deliver data at much higher rates
            - uses cable modem which connects to CMTS
            - CMTS (Cable Modem Termination System)
                * connects lots of different cable connections to ISP's core network
        * Fiber connections
            - uses optical instead of electrical signals which can transmit over long distances without degradation
            - ONT (Optical Network Terminator)
                * converts data from protocols that fiber network can understand to those that the twisted-pair copper networks can understand

* Wide Area Networks (WANs)
    * Acts like a single network that spans multiple physical locations
    * Requires contracting a link across the Internet with your ISP

* Point-to-Point VPNs
    * aka Site-to-Site VPNs act a lot like individual users sitting on either sides of a network except for the fact that the tunneling logic is managed by a network device so that users don't have to establish their own connections


Wireless Networks
-----------------

* Specifications in IEEE 802.11 family make up the set of technologies called WiFi.
* Wireless networking devices communicate to each other through Radio Waves.
* Frequency band is a certain section of radio spectrum that is agreed upon to be used for certain communications
    - In North America, FM radio transmissions operate between 88-108 MHz. This specific frequency band is called FM broadcast band.
    - WiFi networks operate on a few different frequency bands, most commonly, 2.4GHz and 5GHz.

* In terms of networking model, 802.11 defines the physical and data link layers.

* Wireless Access Point (WAP)
    - a device that bridges the wireless and wired portions of a network

* Dissecting an 802.11 Frame

+-------------+----------------+----------+----------+----------+-----------+----------+-----------------+--------+
| FrameCtl(2B)| duration/ID(2B)| Addr1(6B)| Addr2(6B)| Addr3(6B)| SeqCtl(2B)| Addr4(6B)| Payload(0-7951B)| FCS(4B)|
+-------------+----------------+----------+----------+----------+-----------+----------+-----------------+--------+

- Usually, destination and receiver address are the same.
- Usually, source and transmitter address are the same.
- Addr1,2,3,4 are MAC addresses.


* Wireless Network Configurations
    - Ad-hoc networks
    - Wireless LANs (WLANs)
    - Mesh networks

* Wireless Channels
    - individual smaller sections of the overall frequency band used by a wireless network
    - used to solve the problem of collision domain for wireless networks (similar to how switches were solved this problem for wired network - ethernet)

* Wireless Security

    _Wired connections have an inherent security aspect in the sense that only the two nodes at either end of the link have access to data being transmitted._

    - WEP (Wired Equivalent Privacy) an encryption technology that provides very low level of privacy. A bad actor can break through this encryption and read through the data. WEP uses 40-bit encryption key.
    - WPA (WiFi Protected Access) uses 128-bit encryption key.
    - WPA2 uses 256-bit encryption key.
    - MAC Filtering can be configured in access points to allow connections from MAC addresses of trusted devices.


* Cellular Networking
    - Like WiFi, cellular networking uses Radio Waves and specific frequency bands.
    - One big difference compared to WiFi is that these frequencies can travel over much longer distance (in kms or miles).
    - Cell towers can be thought of as access points with much larger range.

    - Devices like cell phones, tablets and even automobiles have started using cellular networking.
