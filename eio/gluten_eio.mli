(*----------------------------------------------------------------------------
 *  Copyright (c) 2022 António Nuno Monteiro
 *
 *  All rights reserved.
 *
 *  Redistribution and use in source and binary forms, with or without
 *  modification, are permitted provided that the following conditions are met:
 *
 *  1. Redistributions of source code must retain the above copyright notice,
 *  this list of conditions and the following disclaimer.
 *
 *  2. Redistributions in binary form must reproduce the above copyright
 *  notice, this list of conditions and the following disclaimer in the
 *  documentation and/or other materials provided with the distribution.
 *
 *  3. Neither the name of the copyright holder nor the names of its
 *  contributors may be used to endorse or promote products derived from this
 *  software without specific prior written permission.
 *
 *  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
 *  AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
 *  IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
 *  ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE
 *  LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
 *  CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
 *  SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
 *  INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
 *  CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
 *  ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
 *  POSSIBILITY OF SUCH DAMAGE.
 *---------------------------------------------------------------------------*)

module Server : sig
  val create_connection_handler :
     read_buffer_size:int
    -> protocol:'t Gluten.runtime
    -> 't
    -> Eio.Net.Sockaddr.stream
    -> Eio.Flow.two_way
    -> unit

  val create_upgradable_connection_handler :
     read_buffer_size:int
    -> protocol:'t Gluten.runtime
    -> create_protocol:(('reqd -> unit) -> 't)
    -> request_handler:
         (Eio.Net.Sockaddr.stream -> 'reqd Gluten.Server.request_handler)
    -> Eio.Net.Sockaddr.stream
    -> Eio.Flow.two_way
    -> unit
end

module Client : sig
  type t

  val create :
     sw:Eio.Switch.t
    -> read_buffer_size:int
    -> protocol:'t Gluten.runtime
    -> 't
    -> Eio.Flow.two_way
    -> t

  val upgrade : t -> Gluten.impl -> unit
  val shutdown : t -> unit Eio.Promise.t
  val is_closed : t -> bool
  val socket : t -> Eio.Flow.two_way
end
