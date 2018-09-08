package ca.josephroque.bowlingcompanion.transfer

import android.os.Bundle
import android.support.v4.app.DialogFragment
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import ca.josephroque.bowlingcompanion.App
import ca.josephroque.bowlingcompanion.R
import ca.josephroque.bowlingcompanion.common.fragments.BaseDialogFragment
import ca.josephroque.bowlingcompanion.database.DatabaseHelper
import kotlinx.android.synthetic.main.dialog_transfer.view.*
import java.lang.IllegalArgumentException

/**
 * Copyright (C) 2018 Joseph Roque
 *
 * A fragment to enable transferring the user's data to a new device, or transferring from another device to their current one.
 */
class TransferDialogFragment : BaseDialogFragment() {

    companion object {
        @Suppress("unused")
        private const val TAG = "TransferDialogFragment"

        fun newInstance(): TransferDialogFragment {
            return TransferDialogFragment()
        }
    }

    private val onClickListener = View.OnClickListener {
        val newFragment = when (it.id) {
            R.id.btn_export -> TransferExportDialogFragment.newInstance()
            R.id.btn_import -> TransferImportDialogFragment.newInstance()
            R.id.btn_restore_delete -> TransferRestoreDeleteDialogFragment.newInstance()
            else -> throw IllegalArgumentException("$TAG: button not set up in onClickListener")
        }

        fragmentNavigation?.pushDialogFragment(newFragment)
    }

    // MARK: Lifecycle functions

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setStyle(DialogFragment.STYLE_NORMAL, R.style.Dialog)
    }

    override fun onCreateView(inflater: LayoutInflater, container: ViewGroup?, savedInstanceState: Bundle?): View? {
        val view = inflater.inflate(R.layout.dialog_transfer, container, false)

        setupToolbar(view)
        view.btn_export.setOnClickListener(onClickListener)
        view.btn_import.setOnClickListener(onClickListener)
        view.btn_restore_delete.setOnClickListener(onClickListener)

        return view
    }

    override fun onStart() {
        super.onStart()
        DatabaseHelper.closeInstance()
    }

    override fun dismiss() {
        App.hideSoftKeyBoard(activity!!)
        activity?.supportFragmentManager?.popBackStack()
        super.dismiss()
    }

    // MARK: Private functions

    private fun setupToolbar(rootView: View) {
        rootView.toolbar_transfer.apply {
            setTitle(R.string.transfer_data)
            setNavigationIcon(R.drawable.ic_dismiss)
            setNavigationOnClickListener {
                dismiss()
            }
        }
    }
}
