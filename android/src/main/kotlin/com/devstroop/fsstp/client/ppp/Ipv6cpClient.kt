package com.devstroop.fsstp.client.ppp

import com.devstroop.fsstp.client.ClientBridge
import com.devstroop.fsstp.client.ControlMessage
import com.devstroop.fsstp.client.Result
import com.devstroop.fsstp.client.Where
import com.devstroop.fsstp.unit.ppp.Ipv6cpConfigureAck
import com.devstroop.fsstp.unit.ppp.Ipv6cpConfigureFrame
import com.devstroop.fsstp.unit.ppp.Ipv6cpConfigureReject
import com.devstroop.fsstp.unit.ppp.Ipv6cpConfigureRequest
import com.devstroop.fsstp.unit.ppp.option.Ipv6cpIdentifierOption
import com.devstroop.fsstp.unit.ppp.option.Ipv6cpOptionPack


internal class Ipv6cpClient(bridge: ClientBridge) : ConfigClient<Ipv6cpConfigureFrame>(Where.IPV6CP, bridge) {
    override fun tryCreateServerReject(request: Ipv6cpConfigureFrame): Ipv6cpConfigureFrame? {
        val reject = Ipv6cpOptionPack()

        if (request.options.unknownOptions.isNotEmpty()) {
            reject.unknownOptions = request.options.unknownOptions
        }

        return if (reject.allOptions.isNotEmpty()) {
            Ipv6cpConfigureReject().also {
                it.id = request.id
                it.options = reject
                it.options.order = request.options.order
            }
        } else null
    }

    override fun tryCreateServerNak(request: Ipv6cpConfigureFrame): Ipv6cpConfigureFrame? {
        return null
    }

    override fun createServerAck(request: Ipv6cpConfigureFrame): Ipv6cpConfigureFrame {
        return Ipv6cpConfigureAck().also {
            it.id = request.id
            it.options = request.options
        }
    }

    override fun createClientRequest(): Ipv6cpConfigureFrame {
        val request = Ipv6cpConfigureRequest()

        request.options.identifierOption = Ipv6cpIdentifierOption().also {
            bridge.currentIPv6.copyInto(it.identifier)
        }

        return request
    }

    override suspend fun tryAcceptClientNak(nak: Ipv6cpConfigureFrame) {
        nak.options.identifierOption?.also {
            it.identifier.copyInto(bridge.currentIPv6)
        }
    }

    override suspend fun tryAcceptClientReject(reject: Ipv6cpConfigureFrame) {
        reject.options.identifierOption?.also {
            bridge.controlMailbox.send(
                ControlMessage(Where.IPV6CP_IDENTIFIER, Result.ERR_OPTION_REJECTED)
            )
        }
    }
}
